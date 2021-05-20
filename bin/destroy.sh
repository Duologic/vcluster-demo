#!/bin/bash
set -euo pipefail

DIRNAME=$(dirname "$0")

NAMESPACE=$(jq -r .namespace < "${DIRNAME}/../config.json")
if kubectl get ns "${NAMESPACE}" >/dev/null; then
    echo -n "This will namespace ${NAMESPACE}, please type 'yes' if you sure: "
    read -r answer
    [ "$answer" == "yes" ] && kubectl delete ns "${NAMESPACE}"
    exit 0
fi
