# kubernetes-cluster
Code of the testing Kubernetes cluster on Scaleway

## Usage

Use Terraform v0.13.4 or higher.
Use Helm v3.4.0 or higher.

Perform these commands to install your helm charts:
- helm repo add grafana https://grafana.github.io/helm-charts
- helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
- helm repo add logzio-helm https://logzio.github.io/logzio-helm/filebeat
- helm repo update

Create the `.env` file from the `env_template` file by adding secret values.

Then, launch these commands:
- source .env && terraform init
- source .env && terraform apply -auto-approve

To access to the Kubernetes dashboard, launch:
- kubectl proxy
Then, go on: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/overview?namespace=default
