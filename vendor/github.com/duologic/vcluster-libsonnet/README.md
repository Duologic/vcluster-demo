# vcluster jsonnet library

Jsonnet library for [vcluster](https://github.com/loft-sh/vcluster) based on their [kubectl
manifests](https://github.com/loft-sh/vcluster/#2-create-a-vcluster).

## Install with Tanka

Initialize a [Tanka](https://tanka.dev) setup without ksonnet:

```console
tk init --k8s=false
```

Install [k8s-alpha](https://github.com/jsonnet-libs/k8s-alpha) as ksonnet alternative:

```console
VERSION="1.17"
jb install github.com/jsonnet-libs/k8s-alpha/"${VERSION}"
echo '(import "github.com/jsonnet-libs/k8s-alpha/'"${VERSION}"'/main.libsonnet")' > lib/k.libsonnet
```

Install vcluster library:

```console
jb install github.com/duologic/vcluster-libsonnet
```

Add vcluster to the environment:

```jsonnet
// environments/default/main.jsonnet
local vcluster = import 'github.com/duologic/vcluster-libsonnet/vcluster/main.libsonnet';

{
  vcluster:
    vcluster(
      name='vcluster',
      namespace='my-vcluster-ns',
      service_cidr='10.96.0.0/12',  # Important: make sure this matches with the Service CIDR of the host cluster.
    ),
}
```
