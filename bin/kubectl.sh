#!/bin/bash
set -euo pipefail

DIRNAME=$(dirname "$0")

source "${DIRNAME}/forward.sh"

sleep 3

kubectl "$@"
