local tk = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local priority_classes = import 'priority-classes.libsonnet';

{
  local name = 'demo',
  local namespace = 'default',
  environment:
    tk.environment.new(name, namespace, 'https://localhost:8443')
    + tk.environment.withData({
      priority_classes: priority_classes,  // needed this to get CoreDNS running, see https://github.com/loft-sh/vcluster/issues/22
    }),
}
