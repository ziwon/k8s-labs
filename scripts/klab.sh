#!/bin/bash

set -euo pipefail
#[[ -n “$DEBUG” ]] && set -x

CUR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

source "$CUR_DIR/../.envrc"
source "$CUR_DIR/common.sh"

configfile=./config/k3d.yaml

prep() {
	info "Cleaning up docker environment..."
	docker rm -f $(docker ps -qa) 2>/dev/null || true
	docker network prune -f
	docker volume prune -f
	docker system prune -a -f

	info "Pulling images..."
	docker pull rancher/k3s:${K3S_VERSION}
	docker pull rancher/k3d-proxy:${K3D_TAG}
	docker pull rancher/k3d-tools:${K3D_TAG}
}

create() {
  echo ">> Creating cluster..."

	mkdir -p ${SHARED_DATA_PATH}
  k3d cluster create --config $configfile
}

delete() {
  echo ">> Deleting cluster..."
  k3d cluster delete --name "${CLUSTER_NAME}"
}

up() {
  echo ">> Starting cluster..."
  k3d cluster start --name "${CLUSTER_NAME}"
}

down() {
  echo ">> Shutdown cluster..."
  k3d cluster stop --name "${CLUSTER_NAME}"
}

launch_docker() {
  echo ">> Docker is running?.."
  set +e
  (docker system info > /dev/null 2>&1)
  if [ "$?" -ne 0 ]; then
    open --background -a Docker && echo -n "Docker is starting..";
    while ! docker system info > /dev/null 2>&1; do echo -e ".\c"; sleep 1; done;
    echo -e "done.\n"
  fi
  set -e
}

case $1 in
	*prep)
		prep
		;;
  *up)
    #launch_docker
		create
    ;;
  *down)
    down
    ;;
  *create)
    create
    ;;
  *delete)
    delete
    ;;
  *)
    echo ">> Unknown: $1"; exit 1;
    ;;
esac
