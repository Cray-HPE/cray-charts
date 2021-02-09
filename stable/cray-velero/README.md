# Cray Velero Chart

Cray packaging of the VMWare Tanzu Velero Chart:

https://github.com/vmware-tanzu/velero

https://github.com/vmware-tanzu/helm-charts

Adds an S3 compatible Ceph RGW backup storage location (BSL), via integration with Shasta's Ceph IAM Provider.

# Installation

Minimally, the following overrides need to be in place before installation via Loftsman:

* ```kubectl.image``` and ```kubectl.tag```
* ```velero.initContainers[0].image``` (AWS Plugin)
* ```velero.configuration.backupStorageLocation.config.s3Url```

# Known Issues

The ```velero-iam``` Kubernetes Secret in the deployed namepsace is only created/updated during a Chart install (via a Helm post-install/upgrad hook). Thus, if the contents of the source Ceph secret should change, the ```velero-iam``` secret may need to be manually updated to match an AWS S3 credential file format. 

Restic is currently used for pod volume backups, where pod volumes are configured using the 'opt-in' model (via pod annotations):

https://velero.io/docs/v1.5/restic/#using-opt-in-pod-volume-backup

Future work in this area may include the use of a CSI volume snapshotter compatible with Ceph, vs. Restic. Note the limitations of Restic:

https://velero.io/docs/v1.0.0/restic/#limitations

Current implementation uses an HTTP transport to Ceph RGW, as Ceph RGW doesn't have an HTTPS interface that has an enrolled platform certificate (cannot import trusted CAs via install). While Velero supports TLS without 'validation', Restic does not. Ultimately, this will be remedied once Ceph RGW is enrolled in platform PKI and platform CAs can be integrated into the deployment for this purpose.

If using on vShasta, you may have to either update the cray-s3 service to point to storage nodes (and possibly add a DNS entry), or otherwise update the BSL config ```s3Url``` with a usable S3 endpoint (e.g., ```kubectl -n velero edit bsl default```). 