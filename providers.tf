terraform {
  backend "gcs" {
    bucket  = "tf-state-kube-cluster"
    prefix  = "terraform/state"
  }
}

provider "helm" {
  kubernetes {
    load_config_file = "false"
    host = module.kube_cluster.kubeconfig[0].host
    token = module.kube_cluster.kubeconfig[0].token
    insecure = true
  }
}

provider "kubernetes" {
  load_config_file = "false"
  host = module.kube_cluster.kubeconfig[0].host
  token = module.kube_cluster.kubeconfig[0].token
  insecure = true
}
