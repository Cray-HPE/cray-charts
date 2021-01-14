# Cray Vault Chart

This deploys an etcd cluster (using the etcd operator) as well as Vault instances (using the Vault operator). This is done as a separate chart as the Vault CRD needs to be registered before deploying.

# Known Applications / Use

- REDS credential storage (kv)
- MEDS credential storage (kv)
- PALS credential storage (kv)
- PKIaaS via Platform Injected CA (pki)

All applications currently use K8S service account authentication.

## PKI Consumers

- cert-manager (uses vault PKI API to sign CSRs)
- hms-scsd and similar services that act as registration authorities / proxies for off-mesh certificate enrollment

# Platform CA Injection

`pki.customCA` settings in `values.yaml` control the behavior of CA injection, and the startup secret used to install the CA, and CA trust bundle information, into Vault. See the documentation in `values.yaml` for details.

# SSH User Certificates

`pki.ssh` settings in `values.yaml` control the behavior of SSH User Certificates. See the documentation in `values.yaml` for details.

# Storage Backend

This chart utilizes Hashicorp Raft for the storage backend. 

# Notes on Scaling

Vault does not scale when we add more nodes. Adding additional nodes is only used to allow another node to take over when the active one fails.

Pay close attention to the cpu and memory request and limit settings in the vault template, and ensure these are maintained across updates to the chart.

# Known Issues

When using Loftsman to downgrade vault to a previous version, the Vault operator has been observed to not fully revert settings from `externalConfig`.

Velero will immediately attempt to schedule a backup when the ```velero-daily-backup.yaml``` CR is installed via this chart. This is a known issue that should hopefully be addressed in a future release:

https://github.com/vmware-tanzu/velero/issues/1980