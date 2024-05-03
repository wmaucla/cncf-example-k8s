# ================== STARTUP ==================

k8s:
	minikube update-check
	minikube start cncf --cpus=5 --memory=30720
	minikube addons enable ingress 
	minikube addons enable ingress-dns

