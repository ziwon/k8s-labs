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
	@$(KLAB) $@

up:
	@$(KLAB) $@

down:
	@$(KLAB) $@
