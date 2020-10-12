# kubernetes-cluster
Code of the testing Kubernetes cluster 

Use Terraform v0.13.4

source .env && terraform init
source .env && terraform apply
export KUBECONFIG=$PWD/kubeconfig
kubectl get node -o wide
