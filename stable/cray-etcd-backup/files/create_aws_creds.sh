#!/bin/sh
# Copyright 2020, Cray Inc. All Rights Reserved.

access_key=$(kubectl get secret -n default etcd-backup-s3-credentials -ojsonpath='{.data.access_key}' | base64 -d)
secret_key=$(kubectl get secret -n default etcd-backup-s3-credentials -ojsonpath='{.data.secret_key}' | base64 -d)
http_s3_endpoint=$(kubectl get secret -n default etcd-backup-s3-credentials -ojsonpath='{.data.http_s3_endpoint}' | base64 -d)

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

echo $http_s3_endpoint > /home/.aws/s3_endpoint

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
