local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
local k_util = import 'github.com/grafana/jsonnet-libs/ksonnet-util/util.libsonnet';

// based on the kubectl manifests from https://github.com/loft-sh/vcluster/#2-create-a-vcluster
function(
  name,
  namespace,
  service_cidr,
  k3s_image='rancher/k3s:v1.17.17-k3s1',
  disk_size='5Gi'
) {
  local this = self,

  local policyRule = k.rbac.v1.policyRule,
  rbac:
    k_util.namespacedRBAC(
      name,
      [
        policyRule.withApiGroups([''])
        + policyRule.withResources([
          'configmaps',
          'secrets',
          'services',
          'services/proxy',
          'pods',
          'pods/proxy',
          'pods/attach',
          'pods/portforward',
          'pods/exec',
          'pods/log',
          'events',
          'endpoints',
          'persistentvolumeclaims',
        ])
        + policyRule.withVerbs(['*']),

        policyRule.withApiGroups(['networking.k8s.io'])
        + policyRule.withResources(['ingresses'])
        + policyRule.withVerbs(['*']),

        policyRule.withApiGroups([''])
        + policyRule.withResources(['namespaces'])
        + policyRule.withVerbs(['get', 'list', 'watch']),

        policyRule.withApiGroups(['apps'])
        + policyRule.withResources(['statefulsets'])
        + policyRule.withVerbs(['get', 'list', 'watch']),
      ],
      namespace
    ),

  local container = k.core.v1.container,
  k3s_container::
    container.new(
      'k3s',
      k3s_image
    )
    + container.withCommand('/bin/k3s')
    + container.withArgs([
      'server',
      '--write-kubeconfig=/k3s-config/kube-config.yaml',
      '--data-dir=/data',
      '--disable=traefik,servicelb,metrics-server,local-storage',
      '--disable-network-policy',
      '--disable-agent',
      '--disable-scheduler',
      '--disable-cloud-controller',
      '--flannel-backend=none',
      '--kube-controller-manager-arg=controllers=*,-nodeipam,-nodelifecycle,-persistentvolume-binder,-attachdetach,-persistentvolume-expander,-cloud-node-lifecycle',
      '--service-cidr=' + service_cidr,
    ])
  ,

  vcluster_container::
    container.new(
      'vcluster',
      'loftsh/virtual-cluster:0.0.27'
    )
    + container.withArgs([
      '--service-name=' + this.service.metadata.name,
      '--suffix=' + name,
      '--owning-statefulset=' + this.statefulset.metadata.name,
      '--out-kube-config-secret=' + name,
    ])
  ,

  local pvc = k.core.v1.persistentVolumeClaim,
  pvc::
    pvc.new('data')
    + pvc.spec.withAccessModes(['ReadWriteOnce'])
    + pvc.spec.resources.withRequests({ storage: disk_size }),


  local statefulset = k.apps.v1.statefulSet,
  statefulset:
    statefulset.new(
      name,
      replicas=1,
      containers=[
        this.k3s_container,
        this.vcluster_container,
      ],
      volumeClaims=[this.pvc]
    )
    + statefulset.spec.template.spec.withServiceAccountName(
      this.rbac.service_account.metadata.name
    )
    + statefulset.spec.withServiceName(this.service_headless.metadata.name)
    + k_util.pvcVolumeMount(this.pvc.metadata.name, '/data')
  ,

  local service = k.core.v1.service,
  local servicePort = k.core.v1.servicePort,

  service:
    k_util.serviceFor(this.statefulset)
    + service.spec.withPorts([
      servicePort.newNamed('https', 443, 8443),
    ]),

  service_headless:
    this.service
    + service.metadata.withName(name + '-headless')
    + service.spec.withClusterIP('None'),
}
