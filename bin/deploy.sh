#!/bin/bash
set -euo pipefail

NAMESPACE=$(cat "${DIRNAME}/../config.json" | jq -r .namespace)
APISERVER=$(cat "${DIRNAME}/../config.json" | jq -r .apiserver)

kubectl delete ns "${NAMESPACE}"
kubectl create ns "${NAMESPACE}"
tk apply --tla-str apiserver="${APISERVER}" environments/vcluster/main.jsonnet
