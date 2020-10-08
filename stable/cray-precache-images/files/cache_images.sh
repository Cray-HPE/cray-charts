#!/bin/sh
#
# Copyright 2020 Hewlett Packard Enterprise Development LP
#
for image in $(cat /scripts/images_to_cache)
do
  echo "Caching image: $image"
  output=$(crictl --runtime-endpoint unix:///run/containerd/containerd.sock pull $image 2>&1)
  echo "  $output"
done
