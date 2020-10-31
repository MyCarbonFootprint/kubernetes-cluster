provider "scaleway" {}

resource "scaleway_k8s_cluster_beta" "testing" {
  name = "test-myfingerprint"
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
