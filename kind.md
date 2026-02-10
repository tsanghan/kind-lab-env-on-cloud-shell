# Tutorial 0

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
```

Check that the kubectl version match with the kubernetes api version of *v1.35.0*
```bash
k version
```
We now apply Gateway API definition
```bash
k apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.1/standard-install.yaml
```

Install *batteries* so our Kubernetes cluster is more interesting to play with.
The following command will install,
1. *Cilium* as CNI
2. *Metallb* as load balancer implementation for Kubernetes that allows you to expose services externally
3. *Metrics Server* a lightweight tool that collects and provides real-time CPU and memory usage metrics from containers and nodes in a Kubernetes cluster
4. *NFS CSI Driver* a Dynamic Volume Provisioner using NFS as storage service
5. *Cert-manager* a powerful and extensible X.509 certificate controller for Kubernetes workloads
```bash
(cilium install --wait && metallb.sh && metrics-server.sh && nfs-storage-class.sh && cert-manager.sh) >/dev/null 2>&1 & k9s -A
```
Wait for the *STATUS* of all Pods to be *Running* before procedding.\
We now have a Kubernetes cluster up and running.\
If you are interested, you may wan to view and read the various *shell scripts* above.\
Click the *Open Editor* icon, first icon on the left on the top right corner.\
Click *view* and click *Toggle Hidden Files*.\
All *shell scripts* are in *~/.local/bin* directory.\
Click on the *+* sign to start a 2nd *cloudshell* in a new tab.\
We can now move on to tutorial 1 with the follown command.
```bash
source ~/.bashrc
teachme ~/cloudshell_open/kind-lab-env-on-cloud-shell/tutorial1.md
```