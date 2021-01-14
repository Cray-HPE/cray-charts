#!/bin/sh

name=k8s-block-replicated
storageclasses=$(kubectl get storageclass -o jsonpath='{range .items[?(@.metadata.name != "'$name'")]}{@.metadata.name} {end}')
for sc in $storageclasses; do
  kubectl patch storageclass $sc -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
done
kubectl patch storageclass $name -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
