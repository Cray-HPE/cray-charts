# Cray Istio Chart

Istio configuration for the Cray system.

This runs after cray-istio-deploy which creates the Istio CRDs that
are used by this chart (Gateways, VirtualServices, etc.).

Currently the Istio 1.5.4 istio-ingress chart is included as a subchart.
In the Istio 1.5.4 release, this can be found in
install/kubernetes/operator/charts/gateways/.
There are a couple of changes:

1) `templates/gateway.yaml` is removed. Istio doesn't allow this Gateway to be
   disabled without disabling the istio-ingressgateway component. We need the
   ingressgateway Deployment but the Gateway doesn't provide the configuration
   that we need. cray-istio has always defined the ingress Gateway (also for hmn)
   so we don't need/want the one created by istio-operator. My understanding is
   that Istio 1.6 does not create the Gateway as part of istio-ingressgateway so
   this should change in 1.6.

2) The chart is renamed to `istio`. This allows our old values.yaml to continue
   to work and provide the settings for istio-ingressgateway without changes.

In order to support deploying the hmn gateway in the same way we support the
istio-ingressgateway, the `istio` subchart that was created using the
instructions above is copied into the `ingressgatewayhmn` subchart. Along with
2 changes:

1) The `gateways` field used is `istio-ingressgateway-hmn` rather than
   `istio-ingressgateway`. Anything setting values for the hmn ingress must
   use ingressgatewayhmn:gateways:istio-ingressgateway-hmn.

2) The "default" Sidecar template is removed. It's created by the istio subchart
   so can't be included here.

Istio/envoy 1.5.4 has a transfer encoding validation bug that breaks APIs that
use 'chunked' encoding.  This is fixed in 1.5.6 and beyond, but this helm chart
has a workaround that modifies a runtime setting by exec'ing into istio-proxy
pods via a cronjob and modifies the runtime config.  See
https://github.com/istio/istio/issues/23020 and
https://github.com/envoyproxy/envoy/issues/10041 for more information.  Once
we upgrade to a version of istio that contains this fix, we can remove the
following from this chart:

  - files/modify_runtime.sh
  - templates/te-bug-workaround.yaml
