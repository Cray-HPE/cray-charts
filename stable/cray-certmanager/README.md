# Overview

Actuate upstream cert-manager chart install.

Depends on cray-certmanager-init chart for CRD, namespace (Istio Injected), and other setup.

# Compatibility
Excerpted from https://cert-manager.io/docs/concepts/project-maturity/:

> cert-manager has a hard guarantee of compatibly with the current stable upstream Kubernetes version. Beyond this, cert-manager also aims to be compatible with versions down to N-4, where N is the current upstream version release. This means that if the current version is v0.16, cert-manager aims to be compatible with versions down to v0.12. This is done by running periodic end-to-end test jobs against each version of Kubernetes.

> Versions lower than the current Kubernetes version down to N-4 is not guaranteed. Although considerations will be made to ensure compatibility with as many versions as possible, it is sometimes required to lose compatibility in the interest of furthering the feature set of cert-manager and making use of newer features available in upstream Kubernetes.

> As of cert-manager version v0.11, the lowest Kubernetes version supported is v1.12.

## Values

The following customization exists:

* Replica count and anti-affinity for all cert-manager pods (webhook, cainjector, controller)
* Modification of cert-manager service name to match loftsman deployment naming
* Use of --enable-certificate-owner-ref=true in extra args to force 'cascading' secret delete on certificate delete. See https://github.com/jetstack/cert-manager/issues/296 for details.
