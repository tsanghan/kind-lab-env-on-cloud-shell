#!/usr/bin/env bash
docker network create \
  --driver=bridge \
  --subnet=10.254.254.0/24 \
  --gateway=10.254.254.1 \
  --opt "com.docker.network.bridge.enable_ip_masquerade"="true" \
  --opt "com.docker.network.driver.mtu"="1500" \
  --ipv6 --subnet=fc00:f853:ccd:e793::/64 \
  kind