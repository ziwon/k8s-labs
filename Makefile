.SILENT: ; # no need for @

KLAB=./scripts/klab.sh

tools: ## Install tools to your local machine
	echo "Installing k3d..."
	curl -sSL https://raw.githubusercontent.com/rancher/k3d/main/install.sh | TAG=$(K3D_TAG) bash

prep create up down delete: tools
	$(KLAB) $@

kubeconfig:
	k3d kubeconfig get $(CLUSTER_NAME) > .kubeconfig

install-helm:
	helm repo list || true
	helm repo add "stable" "https://charts.helm.sh/stable" --force-update
	helm repo add "common" "https://charts.helm.sh/incubator" --force-update
	helm repo update

install-zookeeper:
	helm install zookeeper common/zookeeper

install-kafka:
	kubectl apply -f modules/kafka/kafka.yaml
