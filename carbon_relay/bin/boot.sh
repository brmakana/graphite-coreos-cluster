#!/bin/bash

# Fail hard and fast
set -eo pipefail
. /etc/environment
export ETCD_PORT=${ETCD_PORT:-4001}
export HOST_IP=${HOST_IP:-172.17.42.1}
export ETCD=$HOST_IP:4001

echo "[carbon-relay] booting container. ETCD: $ETCD"

# Loop until confd has updated the config, unless we're overriding that
if [[ -z "$IGNORE_ETCD" ]]
then
	until confd -onetime -node $ETCD -config-file /etc/confd/conf.d/carbon.toml; do
	  echo "[carbon-relay] waiting for confd to refresh carbon.conf (waiting for nodes to be available)"
	  sleep 5
	done
fi

echo "[carbon-relay] starting carbon-relay"
/var/lib/graphite/bin/carbon-relay.py --debug start
