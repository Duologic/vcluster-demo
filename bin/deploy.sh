#!/bin/bash
set -euo pipefail

DIRNAME=$(dirname "$0")

NAMESPACE=$(jq -r .namespace < "${DIRNAME}/../config.json")
APISERVER=$(jq -r .apiserver < "${DIRNAME}/../config.json")
sh "${DIRNAME}/destroy.sh"
if ! kubectl get ns "${NAMESPACE}" >/dev/null; then
    kubectl create ns "${NAMESPACE}"
fi
tk apply --tla-str apiserver="${APISERVER}" environments/vcluster/main.jsonnet
