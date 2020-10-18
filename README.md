# kubernetes-cluster
Code of the testing Kubernetes cluster 

Use Terraform v0.13.4

source .env && terraform init
source .env && terraform apply -auto-approve -target scaleway_k8s_cluster_beta.testing -target scaleway_k8s_pool_beta.testing -target local_file.kubeconfig 
source .env && terraform apply -auto-approve
export KUBECONFIG=$PWD/kubeconfig
kubectl get node -o wide

kubectl proxy
then go on: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/overview?namespace=default
