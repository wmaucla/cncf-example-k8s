# ================== STARTUP ==================

k8s:
	minikube update-check
	minikube start my-app
	minikube addons enable ingress 
	minikube addons enable ingress-dns

