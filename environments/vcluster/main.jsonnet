local config = import '../../config.json';
local tk = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local vcluster = import 'vcluster/main.libsonnet';

{
  environment:
    tk.environment.new(config.name, config.namespace, config.apiserver)
    + tk.environment.withData({
      vcluster:
        vcluster(config.name, config.namespace, config.service_cidr),
    }),
}
