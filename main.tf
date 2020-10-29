provider "scaleway" {}

terraform {
  backend "gcs" {
    bucket  = "tf-state-kube-cluster"
    prefix  = "terraform/state"
  }
}

resource "scaleway_k8s_cluster_beta" "testing" {
  name = "test-myfingerprint"
  description = "testing cluster"
  version = "1.19.3"
  cni = "cilium"
  enable_dashboard = true
  ingress = "nginx"
}

resource "scaleway_k8s_pool_beta" "testing" {
  cluster_id = scaleway_k8s_cluster_beta.testing.id
  name = "default"
  node_type = "DEV1-M"
  size = 1
  autohealing = true
}

provider "kubernetes" {
  load_config_file = "false"

  host = scaleway_k8s_cluster_beta.testing.kubeconfig[0].host
  token = scaleway_k8s_cluster_beta.testing.kubeconfig[0].token
  insecure = "true"
}

resource "kubernetes_secret" "docker" {
  metadata {
    name = "docker-cfg"
  }

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "${var.registry_server}": {
      "auth": "${base64encode("${var.registry_username}:${var.registry_password}")}"
    }
  }
}
DOCKER
  }

  type = "kubernetes.io/dockerconfigjson"
}
