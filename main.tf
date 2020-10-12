provider "scaleway" {}

resource "scaleway_k8s_cluster_beta" "testing" {
  name = "test-myfingerprint"
  description = "testing cluster"
  version = "1.19.2"
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

resource "local_file" "kubeconfig" {
  content = scaleway_k8s_cluster_beta.testing.kubeconfig[0].config_file
  filename = "${path.module}/kubeconfig"
}

output "cluster_url" {
  value = scaleway_k8s_cluster_beta.testing.apiserver_url
}
