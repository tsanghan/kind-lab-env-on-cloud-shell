#!/usr/bin/env bash
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm install metrics-server metrics-server/metrics-server \
  --set args={--kubelet-insecure-tls=true}
kubectl wait --namespace=default \
             --for=condition=ready pod \
             --selector=app.kubernetes.io/instance=metrics-server \
             --timeout=180s