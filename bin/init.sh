#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

VERSION=${1:-1.17}

tk init --k8s=false --inline --force
jb install github.com/jsonnet-libs/k8s-alpha/"${VERSION}"
jb install github.com/grafana/jsonnet-libs/ksonnet-util
jb install github.com/grafana/jsonnet-libs/tanka-util
jb install github.com/duologic/vcluster-libsonnet

echo '(import "github.com/jsonnet-libs/k8s-alpha/'"${VERSION}"'/main.libsonnet")' > lib/k.libsonnet
