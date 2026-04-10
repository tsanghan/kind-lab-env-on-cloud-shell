# Tutorial 1

The following commands deploy EnvoyGateway, a Gateway Controller with EnvoyGateway CRDs

```bash#cloud#vm
helm template eg oci://docker.io/envoyproxy/gateway-crds-helm --version v1.7.1  --set crds.gatewayAPI.enabled=false --set crds.envoyGateway.enabled=true | k apply -f -
helm install eg oci://docker.io/envoyproxy/gateway-helm --version v1.7.1 -n envoy-gateway-system --create-namespace --skip-crds
```

While waiting for *helm* to complete EonvoyGateway deployment, you can click on the *cloudshell* tab where *k9s* is running to observer what Pod/Pods is/are deployed.

We like to deploy an application from [Install the GatewayClass, Gateway, HTTPRoute and example app](https://gateway.envoyproxy.io/docs/install/install-helm/)

But let's first explore the manifest file.

Make sure you are on the *cloudshell* tab that has *command prompt*, i.e., not the *cloudshell* tab that *k9s* is running.

```bash#cloud
curl -sSL https://github.com/envoyproxy/gateway/releases/download/v1.7.1/quickstart.yaml -o ~/Projects/kind/quickstart.yaml
```
If you do not have the Editor opened, click the *Open Editor* icon, first icon on the left on the top right corner.

In the *EXPLORER* panel, click *Projects*.

Then click *quickstart.yaml*, the manifest file we just downloaded.

You should be familar with all the *Deployment* & *Service*, and propabliy *ServiceAccount* resources.

Please explore and be familar with *GatewayClass*, *Gateway* & *HTTPRoute* resources.

For the specifications of various *Gateway API* type, please refer to [Gateway API Reference](https://gateway-api.sigs.k8s.io/api-types/gateway/)

We will now apply this *quickstart.yaml* manifest into *default* namespace.

Please make sure your *command prompt* *cloudshell* tab has focus.

```bash#cloud#vm
k apply -f https://github.com/envoyproxy/gateway/releases/download/v1.7.1/quickstart.yaml -n default
```
You may want to ckick on the *k9s* tab to see what is being deployed.

Check the status of *Gateway* resource

Make sure you are back on the *command prompt* tab.

```bash#cloud#vm
k get gateway -A
```

You will see some output similar to what is shown below.
We only have 1 *Gateway* resource in *Default* namespace.
```none
NAMESPACE   NAME   CLASS   ADDRESS          PROGRAMMED   AGE
default     eg     eg      10.254.254.248   True         6m12s
```

We have a *Gateway* resource with *eg* as the name of the resource.

This *eg* *Gateway* resource has been assigned an IP address of *10.254.254.248* and *PROGRAMMED=True*.

Please see [PROGRAMMED](https://gateway-api.sigs.k8s.io/geps/gep-1364/?h=programmed#programmed)

To get the *port* number the *eg* *Gateway* is listeninig on.
```bash#cloud#vm
k get gateway eg -oyaml | yq '.spec.listeners'
```

You will get a similar output shown below
```none
- allowedRoutes:
    namespaces:
      from: Same
  name: http
  port: 80
  protocol: HTTP
```

There is only 1 item under *.spec.listerners*, and the port number is *80*

Let us now check *Httproute* resource
```bash#cloud#vm
k get httproutes -A
```

You will see some output similar to what is show below.

We only have 1 *Httproute* resource in *Default* namespace.
```none
NAMESPACE   NAME      HOSTNAMES             AGE
default     backend   ["www.example.com"]   14m
```

We have a *Httproute* resource with *backend* as the name of the resource.

The *backend* *Httproute* resource has been configured with a *HOSTNAME* of *www.example.com*

We will now try to access the backend application.
```bash#cloud#vm
DOMAIN=$(k get httproute backend -oyaml | yq '.spec.hostnames[]')
PORT=$(k get gateway eg -oyaml | yq '.spec.listeners[].port')
IP=$(k get gateway eg -oyaml | yq '.status.addresses[].value')
curl --resolve $DOMAIN:$PORT:$IP http://$DOMAIN
```

Or

```bash
DOMAIN=$(k #cloud#vmget httproute backend -oyaml | yq '.spec.hostnames[]')
PORT=$(k get gateway eg -oyaml | yq '.spec.listeners[].port')
IP=$(k get gateway eg -oyaml | yq '.status.addresses[].value')
xh --resolve $DOMAIN:$IP http://$DOMAIN
```

