#!/bin/sh
# Copyright 2020, Cray Inc. All Rights Reserved.

access_key=$(kubectl get secret -n services etcd-backup-s3-credentials -ojsonpath='{.data.access_key}' | base64 -d)
secret_key=$(kubectl get secret -n services etcd-backup-s3-credentials -ojsonpath='{.data.secret_key}' | base64 -d)
#
# TODO: Uncomment the following to use https://rgw-vip.local, at which point we don't need to disable
#       cert validation (not supported in the current etcd operator bits).
#
# s3_endpoint=$(kubectl get secret -n services etcd-backup-s3-credentials -ojsonpath='{.data.s3_endpoint}' | base64 -d)
s3_endpoint='http://rgw.local:8080'

mkdir /home/.aws

cat > /home/.aws/credentials <<EOF
[default]
aws_access_key_id = $access_key
aws_secret_access_key = $secret_key
EOF

cat > /home/.aws/config <<EOF
[default]
region=foo
EOF

echo $s3_endpoint > /home/.aws/s3_endpoint

for ns in default services vault operators
do
    output=$(kubectl get secret -n $ns etcd-backup-restore-aws-config 2>&1)
    rc=$?
    if [ $rc -eq 0 ]; then
        echo "etcd-backup-restore-aws-config secret already exists in $ns namespace"
        continue
    fi
    kubectl -n $ns create secret generic etcd-backup-restore-aws-config --from-file=/home/.aws/credentials --from-file=/home/.aws/config --from-file=/home/.aws/s3_endpoint
done
