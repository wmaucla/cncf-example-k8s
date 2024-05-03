# CNCF Example

This repo is designed to build out a fully fledged k8s stack leveraging all tools from the Cloud Native Computing Foundation or part of the Linux foundation.

Current features:

* OpenTofu for IaC
* Harbor for container registry
* Prometheus / Grafana for monitoring
* Minikube for k8s
* ArgoCD for CI/CD

### Harbor

Harbor for container registry:
![](images/harbor.png)

In order to configure the ability for harbor to work with minikube and allow for publishing images to the harbor registry, instructions are found [here](https://loft.sh/blog/harbor-kubernetes-self-hosted-container-registry/).

### ArgoCD

ArgoCD setup for continuous delivery:

![](images/argo.png)

Note that argo is connected to another repo, [python-api](https://github.com/wmaucla/python-api), separated to make it easier to follow and mimic best practices. The image does need to be built manually (in absense of a CI system) within the minikube context to make it available to pull.

## Notes on Setup

For general invoking of tf within minikube, need

```bash
export KUBE_CONFIG_PATH=~/.kube/config
```

For backstage, need to run:

```bash
eval $(minikube docker-env)
yarn build-image --tag backstage:1.0.0
```