#!/bin/bash
set -u
IFS=$'\n\t'

DIRNAME=$(dirname "$0")
TEMPFILE=$(mktemp)

NAME=$(cat "${DIRNAME}/../config.json" | jq -r .name)
NAMESPACE=$(cat "${DIRNAME}/../config.json" | jq -r .namespace)

kubectl -n "${NAMESPACE}" get secrets "${NAME}-0" -o json | jq -r .data.config | base64 -d > "${TEMPFILE}"

kubectl port-forward -n "${NAMESPACE}" "${NAME}-0-0" 8443 >/dev/null &
FPID=$!
echo $FPID

export KUBECONFIG=${TEMPFILE}

_trap_forward () {
  unset KUBECONFIG
  # kill not really needed, subshell will kill the background job
  kill $FPID
  rm "${TEMPFILE}"
}
trap _trap_forward EXIT
