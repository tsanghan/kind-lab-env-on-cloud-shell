#!/usr/bin/env bash
helm repo add jetstack https://charts.jetstack.io
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version $CERT_MANAGER_VER \
  --set crds.enabled=true \
  --set "extraArgs={--enable-gateway-api=true}"