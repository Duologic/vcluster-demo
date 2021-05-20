local config = import '../../config.json';
local vcluster = import 'github.com/duologic/vcluster-libsonnet/vcluster/main.libsonnet';
local tk = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';

{
  environment:
    tk.environment.new(config.name, config.namespace, config.apiserver)
    + tk.environment.withData({
      vcluster:
        vcluster(config.name, config.namespace, config.service_cidr),
    }),
}
