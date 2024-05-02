# CNCF Example

This repo is designed to build out a fully fledged k8s stack leveraging all tools from the Cloud Native Computing Foundation or part of the Linux foundation.

Current features:

* OpenTofu for IaC
* Harbor for container registry
* Prometheus / Grafana for monitoring
* Minikube for k8s
* ArgoCD for CI/CD

## Notes on Setup

For backstage, need to run:

```bash
eval $(minikube docker-env)
yarn build-image --tag backstage:1.0.0
```