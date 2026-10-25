CLUSTER_NAME?=demystifying-cni

.PHONY: cluster create init setup start
cluster create init setup start:
	docker image inspect alpine:latest >/dev/null 2>&1 || docker pull alpine:latest
	kind create cluster --config kind.yaml --name ${CLUSTER_NAME}
	ARCH=$$(uname -m | sed -e 's/x86_64/amd64/' -e 's/aarch64/arm64/'); \
	docker save alpine:latest | docker exec -i ${CLUSTER_NAME}-control-plane ctr --namespace=k8s.io images import --platform linux/$$ARCH -
	kubectl delete deploy -n kube-system coredns
	kubectl delete deploy -n local-path-storage local-path-provisioner

.PHONY: delete destroy stop
delete destroy stop:
	kind delete cluster --name ${CLUSTER_NAME}