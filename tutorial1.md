# Tutorial 1

The following commands deploy EnvoyGateway, a Gateway Controller with EnvoyGateway CRDs

```bash
helm template eg oci://docker.io/envoyproxy/gateway-crds-helm --version v1.7.0  --set crds.gatewayAPI.enabled=false --set crds.envoyGateway.enabled=true | k apply -f -
helm install eg oci://docker.io/envoyproxy/gateway-helm --version v1.7.0 -n envoy-gateway-system --create-namespace --skip-crds
```

While waiting for helm to complet EonvoyGateway deployment, you can click on the *cloudshell* tab where *k9s* is running to observer what Pod/Pods is/are deployed.

We like to deploy an application from [Install the GatewayClass, Gateway, HTTPRoute and example app](https://gateway.envoyproxy.io/docs/install/install-helm/)

Let us first explore the manifest file first.
```bash
curl -sSL https://github.com/envoyproxy/gateway/releases/download/v1.7.0/quickstart.yaml -o ~/Projects/kind/quickstart.yaml
```
If you do not have the Editor opened, click the *Open Editor* icon, first icon on the left on the top right corner.

In the *EXPLORER* panel, click *Projects*.

Then click *quickstart.yaml*, the manifest file we just downloaded.

You should be familar with all the *Deployment* & *Service*, and propabliy *ServiceAccount* resources.

Please explore be familar with *GatewayClass*, *Gateway* & *HTTPRoute* resources.

For the specification of various *Gateway API* type, pelase refer to [Gateway API Reference](https://gateway-api.sigs.k8s.io/api-types/gateway/)

We will now apply this *quickstart.yaml* manifest into *default* namespace.

```bash
k apply -f https://github.com/envoyproxy/gateway/releases/download/v1.7.0/quickstart.yaml -n default
```

Check the status of *Gateway* resource
```bash
k get gateway -A
```

You will see some output similar to what is show below.\
We only have 1 *Gateway* resource in *Default* namespace.
```none
NAMESPACE   NAME   CLASS   ADDRESS          PROGRAMMED   AGE
default     eg     eg      10.254.254.248   True         6m12s
```

We have a *Gateway* resource with *eg* as the name of the resource.\
This *eg* *Gateway* resource has been assigned an IP address of *10.254.254.248* and *PROGRAMMED=True*.\
Please see [PROGRAMMED](https://gateway-api.sigs.k8s.io/geps/gep-1364/?h=programmed#programmed)

To get the *port* number the *eg* *Gateway* is listeninig on.
```bash
k get gateway eg -oyaml | yq '.spec.listeners'
```

You will get a similar output show below
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
```bash
k get httproutes -A
```

You will see some output similar to what is show below.\
We only have 1 *Httproute* resource in *Default* namespace.
```none
NAMESPACE   NAME      HOSTNAMES             AGE
default     backend   ["www.example.com"]   14m
```

We have a *Httproute* resource with *backend* as the name of the resource.\
The *backend* *Httproute* resource has been configured with a *HOSTNAME* of *www.example.com*

We will now try to access the backend application.\
```bash
DOMAIN=$(k get httproute backend -oyaml | yq '.spec.hostnames[]')
PORT=$(k get gateway eg -oyaml | yq '.spec.listeners[].port')
IP=$(k get gateway eg -oyaml | yq '.status.addresses[].value')
curl --resolve $DOMAIN:$PORT:$IP http://$DOMAIN
```

Or

```bash
DOMAIN=$(k get httproute backend -oyaml | yq '.spec.hostnames[]')
PORT=$(k get gateway eg -oyaml | yq '.spec.listeners[].port')
IP=$(k get gateway eg -oyaml | yq '.status.addresses[].value')
xh --resolve $DOMAIN:$IP http://$DOMAIN
```

