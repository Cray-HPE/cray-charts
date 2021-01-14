# Cray Istio Chart

Istio configuration for the Cray system.

This runs after cray-istio-deploy which creates the Istio CRDs that
are used by this chart (Gateways, VirtualServices, etc.).

Currently the Istio 1.6.13 istio-ingress chart is included as a subchart.
In the Istio 1.6.13 release, this can be found in
manifests/charts/gateways/istio-ingress/.
There are a few changes:

1) The chart is renamed to `istio`. This allows our old values.yaml to continue
   to work and provide the settings for istio-ingressgateway without changes.

2) Fixed issue in the upstream chart not actually using values for
   `gateways.*.externalIPs` in the gateway service.

In order to support deploying the hmn gateway in the same way we support the
istio-ingressgateway, the `istio` subchart that was created using the
instructions above is copied into the `ingressgatewayhmn` subchart. Along with
a few changes:

1) The `gateways` field used is `istio-ingressgateway-hmn` rather than
   `istio-ingressgateway`. Anything setting values for the hmn ingress must
   use ingressgatewayhmn:gateways:istio-ingressgateway-hmn.

2) Fixed issue in the upstream chart not actually using values for
  `gateways.*.externalIPs` in the gateway service.
