# Overview

Create cert-manager issuers.

This chart is dependent upon cray-certmanager-init and cray-certmanager charts.

# Values

## Vault-backed Issuers

All values under each issuer (e.g., Services) is required. More issuers can be added by appending to the vaultIssuers array.

A supporting vault configuration must be in place to support each issuer.

```
vaultIssuers:
  Services:
      namespace: services
      vaultServer: "http://cray-vault.vault.svc.cluster.local:8200"
      vaultPKIRole: common
      vaultPKIPath: common/sign
      vaultK8SAuthPath: /v1/auth/kubernetes
```

# Creating Certificates (example)

Verify Issuer:

```
# kubectl get issuer -n services -o yaml
apiVersion: v1
items:
- apiVersion: cert-manager.io/v1alpha3
  kind: Issuer
  metadata:
    creationTimestamp: "2020-04-23T13:53:13Z"
    generation: 2
    name: cert-manager-issuer-common
    namespace: services
    resourceVersion: "1066339"
    selfLink: /apis/cert-manager.io/v1alpha3/namespaces/services/issuers/cert-manager-issuer-common
    uid: 1c0bfb27-00e4-4732-9984-9d15e9d5fd24
  spec:
    vault:
      auth:
        kubernetes:
          mountPath: /v1/auth/kubernetes
          role: common
          secretRef:
            key: token
            name: cert-manager-issuer-common-token-plhw2
      path: pki_common/sign/common
      server: http://cray-vault.vault.svc.cluster.local:8200
  status:
    conditions:
    - lastTransitionTime: "2020-04-23T13:53:18Z"
      message: Vault verified
      reason: VaultVerified
      status: "True"
      type: Ready
kind: List
metadata:
  resourceVersion: ""
  selfLink: ""
```

Manifest you can use to create a certificate against a named cert-manager issuer:

```
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: istio-ingress
  namespace: services
spec:
  secretName: istio-public-ingress.tls
  issuerRef:
    kind: Issuer
    name: cert-manager-issuer-common
  commonName: istio-public-ingress.example.com
  duration: 40m
  renewBefore: 20m
  dnsNames:
    - prometheus-shs.example.com
    - alertmanager-shs.example.com
    - grafana-shs.example.com
    - prometheus-istio.example.com
    - grafana-istio.example.com
    - kiali-istio.example.com
    - jaeger-istio.example.com
    - prometheus-kube.example.com
    - alertmanager-kube.example.com
    - grafana-kube.example.com
    - prometheus-ceph.example.com
    - vcs.example.com
    - sma-grafana.example.com
    - sma-kibana.example.com
```

Create the certificate

```
# kubectl create -f demo-ingress-certificate.yaml
certificate.cert-manager.io/istio-ingress created
```

Verify the certificate is ready:

```
# kubectl get certificate -n services istio-ingress -o yaml
apiVersion: cert-manager.io/v1alpha3
kind: Certificate
metadata:
  creationTimestamp: "2020-04-23T14:21:32Z"
  generation: 1
  name: istio-ingress
  namespace: services
  resourceVersion: "1083056"
  selfLink: /apis/cert-manager.io/v1alpha3/namespaces/services/certificates/istio-ingress
  uid: 7777b471-85fb-4c5a-a60b-05b65f25fa33
spec:
  commonName: istio-public-ingress.example.com
  dnsNames:
  - prometheus-shs.example.com
  - alertmanager-shs.example.com
  - grafana-shs.example.com
  - prometheus-istio.example.com
  - grafana-istio.example.com
  - kiali-istio.example.com
  - jaeger-istio.example.com
  - prometheus-kube.example.com
  - alertmanager-kube.example.com
  - grafana-kube.example.com
  - prometheus-ceph.example.com
  - vcs.example.com
  - sma-grafana.example.com
  - sma-kibana.example.com
  duration: 40m0s
  issuerRef:
    kind: Issuer
    name: cert-manager-issuer-common
  renewBefore: 20m0s
  secretName: istio-public-ingress.tls
status:
  conditions:
  - lastTransitionTime: "2020-04-23T14:21:32Z"
    message: Certificate is up to date and has not expired
    reason: Ready
    status: "True"
    type: Ready
  notAfter: "2020-04-23T15:01:32Z"
```

Delete the certificate:

```
# kubectl delete certificate -n services istio-ingress
certificate.cert-manager.io "istio-ingress" deleted
```

**Note that secrets associated with the certificate will be deleted when the certificate is deleted.**

# Troubleshooting

Some basic steps if certificates are failing to create:

* Verify the cray-certmanager-cert-manager deployments and pods are in a ready state (cert-manager namespace)
* Verify the cray-certmanager-cert-manager service is deployed in the cert-manager namespace
* Use describe on certificate and certificaterequest objects and look at the events, noting vault return status among others
* Verify the issuer status, looking for vault communication/auth status
* Verify the PKI configuration in vault/verify that vault is healthy, one way is to check issuer status
* Verify that the cray-certmanager-cert-manager and cray-certmanager-cert-manager-cainjector pods have an elected leader
* Look for problems with the cert-manager webhook state (validating and mutating), this is a typical area for issues to crop up