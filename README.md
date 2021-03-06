# vcluster demo with Tanka

Testing out [vcluster](https://github.com/loft-sh/vcluster) with [Tanka](https://tanka.dev/).

## Files

There are a few helper scripts in `/bin` that describe the process a bit:

```
bin/
├── apply.sh    # Applies the demo to the virtual cluster.
├── deploy.sh   # Applies the vcluster to the host cluster.
├── destroy.sh  # Destroys the vcluster (deletes namespace).
├── forward.sh  # Sets up the port-forward, used by deploy.sh and k9s.sh.
├── init.sh     # Bootstrapping Tanka and various components.
├── k9s.sh      # Starts k9s on the virtual cluster.
└── kubectl.sh  # Use kubectl on the virtual cluster.
```

The demo configuration can be modified to your needs through the root level `config.json` file. Both the Tanka
environment and scripts read from this file.

```
{
  "name": "vcluster",                   # Name of the virtual cluster.
  "namespace": "my-vcluster",           # Namespace on the host cluster, created by bin/apply.sh.
  "apiserver": "https://127.0.0.1",     # IP of the host cluster, should match an entry in your local kubeconfig.
  "service_cidr": "10.96.0.0/12"        # Important: make sure this matches with the Service CIDR of the host cluster.
}
```

## Demo

To run the demo, configure the `config.json` file and ensure your current kubernetes context matches the `apiserver`.
Then run:

```console
sh bin/deploy.sh
```

This should install the vcluster on the host cluster into the namespace.

The cluster I'm testing on has custom PriorityClasses, the demo environment here also creates these:

```console
sh bin/apply.sh
```

Now inspect your newly created cluster with `k9s` or `kubectl`:

```console
sh bin/k9s.sh
sh bin/kubectl.sh get pods -A
```
