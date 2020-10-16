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
  config_path = local_file.kubeconfig.filename
}

resource "kubernetes_namespace" "dev" {
  metadata {
    annotations = {
      name = "dev"
    }

    name = "dev"
  }

  depends_on = [ local_file.kubeconfig ]
}

resource "kubernetes_secret" "docker" {
  metadata {
    name = "docker-cfg"
    namespace = "dev"
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

  depends_on = [ local_file.kubeconfig ]
}

resource "local_file" "kubeconfig" {
  content = scaleway_k8s_cluster_beta.testing.kubeconfig[0].config_file
  filename = "${path.module}/kubeconfig"
}

output "cluster_url" {
  value = scaleway_k8s_cluster_beta.testing.apiserver_url
}
