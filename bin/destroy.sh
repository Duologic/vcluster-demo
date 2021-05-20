#!/bin/bash
set -euo pipefail

NAMESPACE=$(jq -r .namespace < "${DIRNAME}/../config.json")

kubectl delete ns "${NAMESPACE}"
