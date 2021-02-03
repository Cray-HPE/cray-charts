#!/bin/sh
#
# Copyright 2021 Hewlett Packard Enterprise Development LP
#
# See comment in README.md that describes why we need to alter
# this runtime envoy setting in istio 1.5.4 and 1.6.13 (at
# a minimum).
#
lines=$(kubectl get pods -A -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{"."}{.metadata.namespace}{"."}{.status.phase}{"."}{range .spec.containers[*]}{.name}{"."}{end}{end}' | grep Running | grep istio-proxy)
echo "Ensuring istio-proxy container in the following pods have the setting 'reject_unsupported_transfer_encodings' set to 'false':"
echo ""
for line in $lines
do
  pod=$(echo $line | awk 'BEGIN { FS = "." } ; {print $1}')
  ns=$(echo $line | awk 'BEGIN { FS = "." } ; {print $2}')
  output=$(kubectl -n $ns exec -i $pod -c istio-proxy -- /bin/sh -c 'curl -s -X POST http://localhost:15000/runtime_modify?envoy.reloadable_features.reject_unsupported_transfer_encodings=false' 2>&1)
  echo "  $pod ($ns): $output"
done
