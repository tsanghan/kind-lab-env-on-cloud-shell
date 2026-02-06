#!/usr/bin/env bash
helm repo add metallb https://metallb.github.io/metallb
# helm install metallb metallb/metallb --namespace metallb-system --create-namespace --set loadBalancerClass=metallb
helm install metallb metallb/metallb --namespace metallb-system --create-namespace
kubectl wait --namespace metallb-system \
             --for=condition=ready pod \
             --selector=app.kubernetes.io/name=metallb \
             --timeout=120s
cat <<EOF | kubectl apply -f -
---
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default
  namespace: metallb-system
spec:
  addresses:
  - 10.254.254.248-10.254.254.254

---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: default
  namespace: metallb-system
EOF