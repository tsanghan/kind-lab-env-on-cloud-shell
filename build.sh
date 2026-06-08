#!/usr/bin/env bash

source ./versions.rc

envsubst '$KUBE_VER $GATEWAY_API_VER $ENVOYGATEWAY_VER $CERT_MANAGER_VER $KIND_VER' <templates/README.md.tmpl >README.md
envsubst '$KUBE_VER $GATEWAY_API_VER' <templates/kind.md.tmpl >kind.md
envsubst '$ENVOYGATEWAY_VER' <templates/tutorial1.md.tmpl >tutorial1.md