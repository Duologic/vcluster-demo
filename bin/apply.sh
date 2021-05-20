#!/bin/bash
set -euo pipefail

DIRNAME=$(dirname "$0")

source "${DIRNAME}/forward.sh"

sleep 3

tk apply environments/demo/main.jsonnet
