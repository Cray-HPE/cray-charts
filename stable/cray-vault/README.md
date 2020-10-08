# Cray Vault Chart

This deploys an etcd cluster (using the etcd operator) as well as vault instances (using the vault operator). This is done as a seperate chart as the Vault CRD needs to be registered before deploying.

# pki-init

This chart will run the pki-init container as a post-install job. This container initalizes vault's PKI setup for use with cert-manager. By default it will generate its own CA and intermediate cert. You can also provide a custom cert by putting both the public certificate and private key in one PEM file and providing the contents of that file as a secret. This secret is named pem_bundle and is located under the pki secret in the vault namespace. You will need to create this secret prior to installing cray-vault if you wish to use a non-generated CA.

# Notes on scaling
Vault does not scale when we add more nodes. Adding additional nodes is only used to allow another node to take over when the active one fails.

Pay close attention to the cpu and memory request and limit settings in the vault template, and ensure these are maintained across updates to the chart.