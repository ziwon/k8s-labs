HOME_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
.SILENT: ; # no need for @
include .envrc
export

DEBUG=0
K=kubectl
H=helm
KLAB=./scripts/klab.sh

tools: ## Install tools to your local machine
	echo "Installing k3d..."
	curl -sSL https://raw.githubusercontent.com/rancher/k3d/main/install.sh | TAG=$(K3D_TAG) bash

prep:
	$(KLAB) $@

up:
	$(KLAB) $@

down:
	$(KLAB) $@

delete:
	$(KLAB) $@

kubeconfig:
	k3d kubeconfig get $(CLUSTER_NAME) > .kubeconfig

helm:
	helm repo list
	helm repo add "stable" "https://charts.helm.sh/stable" --force-update
	helm repo add "common" "https://charts.helm.sh/incubator" --force-update
	helm repo update

helm-zookeeper:
	helm install zookeeper common/zookeeper
