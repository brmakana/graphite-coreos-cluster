#!/bin/bash

# Fail hard and fast
set -eo pipefail
. /etc/environment
export ETCD_PORT=${ETCD_PORT:-4001}
export HOST_IP=${HOST_IP:-172.17.42.1}
export ETCD=$HOST_IP:4001

echo "[graphite-web] booting container. ETCD: $ETCD"

# Loop until confd has updated the config
until confd -onetime -node $ETCD -config-file /etc/confd/conf.d/local_settings.toml; do
  echo "[graphite-web] waiting for confd to refresh local_settings.py (waiting for nodes to be available)"
  sleep 5
done

# set the host IP for Grafana
sed -i "s/__GRAPHITE_HOST__/$HOST_IP/" /src/grafana/dist/config.js

# Start
echo "[graphite-web] starting supervisord"
/usr/bin/supervisord