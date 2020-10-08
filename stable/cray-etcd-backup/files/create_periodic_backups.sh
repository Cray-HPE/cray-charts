#!/bin/sh
# Copyright 2020, Cray Inc. All Rights Reserved.

#
# TODO: Uncomment the following to use https://rgw-vip.local, at which point we don't need to disable
#       cert validation (not supported in the current etcd operator bits).
#
# s3_endpoint=$(kubectl get secret -n services etcd-backup-s3-credentials -ojsonpath='{.data.s3_endpoint}' | base64 -d)
s3_endpoint='http://rgw.local:8080'

for line in $(cat /usr/local/sbin/clusters.txt)
do
    project=$(echo $line | awk 'BEGIN { FS = "." } ; {print $1}')
    namespace=$(echo $line | awk 'BEGIN { FS = "." } ; {print $2}')
    seconds=$(echo $line | awk 'BEGIN { FS = "." } ; {print $3}')
    num_backups=$(echo $line | awk 'BEGIN { FS = "." } ; {print $4}')
    tls_secret=$(echo $line | awk 'BEGIN { FS = "." } ; {print $5}')
    ip=$(kubectl get service -n $namespace $project-etcd-client -ojsonpath='{.spec.clusterIP}' 2>&1)
    rc=$?
    if [ $rc -ne 0 ]; then
        continue
    fi

    if [ $tls_secret != "" ]; then

    cat > /tmp/$project-backup.yaml <<EOF
apiVersion: "etcd.database.coreos.com/v1beta2"
kind: "EtcdBackup"
metadata:
  name: $project-etcd-cluster-periodic-backup
  namespace: $namespace
spec:
  etcdEndpoints: [https://$ip:2379]
  storageType: S3
  clientTLSSecret: $tls_secret
  allowSelfSignedCertificates: true
  backupPolicy:
    backupIntervalInSecond: $seconds
    maxBackups: $num_backups
  s3:
    path: etcd-backup/$project/etcd.backup
    awsSecret: etcd-backup-restore-aws-config
    forcePathStyle: true
    endpoint: $s3_endpoint
EOF

    else

    cat > /tmp/$project-backup.yaml <<EOF
apiVersion: "etcd.database.coreos.com/v1beta2"
kind: "EtcdBackup"
metadata:
  name: $project-etcd-cluster-periodic-backup
  namespace: $namespace
spec:
  etcdEndpoints: [http://$ip:2379]
  storageType: S3
  backupPolicy:
    backupIntervalInSecond: $seconds
    maxBackups: $num_backups
  s3:
    path: etcd-backup/$project/etcd.backup
    awsSecret: etcd-backup-restore-aws-config
    forcePathStyle: true
    endpoint: $s3_endpoint
EOF

    fi

    kubectl -n $namespace apply -f /tmp/$project-backup.yaml
  
done
