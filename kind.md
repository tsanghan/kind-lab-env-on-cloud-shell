Please check that you are in the directory *~/cloudshell_open/kind-lab-env-on-cloud-shell*

We have to setup Clound Shell with utilities and tools we need to create Kind Kubernetes cluster.
```bash
./setup.sh
```

We will now create a Kind Kubernetes cluster
```bash
source ~/.bashrc
cd ~/Projects/kind
kind create cluster --config kind-v1.35.0.yaml
cilium install
cilium status --wait
metallb.sh
metrics-server.sh
nfs-storage-class.sh
```
