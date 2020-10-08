# Overview

Loads CRDs for cert-manager v0.14.1 conditioned upon the version of K8S installed. Note that, for K8S versions < 1.15, the webhook does not provide up-rev/down-rev API conversion for cert-manager ```Certificate``` and ```CertificateRequest``` resources. The CRDs have also been modified to account for changes in the Helm/Loftsman deployment name (e.g., ```cray-certmanager-*``` vs. ```cert-manager-*```). The current configuration requires cert-manager to be installed into the ```cert-manager``` namespace, v0.15.0+ of cert-manager should eventually honor this via values in the chart directly, and install templated CRDs. 

Creates the ```cert-manager``` namespace that, by default, has istio-injection enabled. This is currently a requirement due to cert-manager and vault/bank-vaults integration.

This chart is a dependency of the cray-certmanager chart, as it loads CRDs, creates a namespace, and manages Istio env for the namespace and cert-manager webhook.

## Values

```
namespace:
   name: cert-manager
   istio-injection: enabled
```

Namespace changes **must** be propagated to the cray-certmanager chart, and will require CRD modifications, etc.

If istio-injection equals ```enabled```, the namespace will be annotated for istio-injectio.