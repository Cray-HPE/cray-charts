
This chart creates the IstioOperator object for the Cray system.
It will be run after the cray-istio-operator chart starts the Istio Operator which defines the IstioOperator custom resource.

Istio is currently configured using the Helm passthrough method, see the info box on
https://archive.istio.io/v1.5/docs/setup/install/istioctl/#customizing-the-configuration .
The Helm passthrough method is used because we used Helm previously and this
makes for minimal changes to the config.

Note that this chart is configured to disable the ingress gateway component.
This is because Istio 1.5 has a bug/limitation where it always deploys a Gateway
but it doesn't provide the options that we're already using for that Gateway.
The ingress-gateway is deployed by the cray-istio chart which runs after this
chart.
See https://github.com/istio/istio/issues/21577 for a discussion of the bug.
According to this issue the Gateway doesn't get created in 1.6. If that's the
case we can change this chart to enable the ingress-gateway component.
