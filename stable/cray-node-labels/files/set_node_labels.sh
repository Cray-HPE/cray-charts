#!/bin/bash
#
# Copyright 2021 Hewlett Packard Enterprise Development LP
#
for line in $(cat /scripts/node_labels)
do
  cnt=0
  IFS=':' list=($line)
  for item in "${list[@]}"
  do
    cnt=$((cnt+1))
    if [ "$cnt" -eq 1 ]; then
      node=$item
      continue
    fi
    cnt2=0
    IFS='=' list2=($item)
    for item2 in "${list2[@]}"
    do
      cnt2=$((cnt2+1))
      if [ "$cnt2" -eq 1 ]; then
        key=$item2
      else
        value=$item2
      fi
    done
    echo "Setting label: $key to value: $value for node: $node"
    kubectl label node $node "$key=$value" --overwrite
    rc=$?
    if [ "$rc" -ne 0 ]; then
      echo "ERROR: Failed to set label: $key to value: $value for node: $node"
    fi
  done
done
