
module "kube_cluster" {
  source = "./tf_modules/kube_cluster/"
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

resource "helm_release" "grafana" {
  name      = "grafana"
  chart     = "grafana/grafana"

  values = [
    file("grafana/values.yaml")
  ]

  set {
    name  = "ingress.hosts"
    value = "{grafana${replace(module.kube_cluster.cluster_wildcard_dns, "*", "")}}"
  }
  set {
    name = "grafana.ini.server.domain"
    value = "grafana${replace(module.kube_cluster.cluster_wildcard_dns, "*", "")}"
  }
}

resource "helm_release" "prometheus" {
  name      = "prometheus"
  chart     = "prometheus-community/prometheus"

  values = [
    file("prometheus/values.yaml")
  ]

  set {
    name  = "server.ingress.hosts"
    value = "{prometheus${replace(module.kube_cluster.cluster_wildcard_dns, "*", "")}}"
  }
}

resource "helm_release" "logzio" {
  name      = "logzio"
  chart     = "logzio-helm/logzio-k8s-logs"

  set_sensitive {
    name  = "secrets.logzioShippingToken"
    value = var.logzio_token
  }

  set {
    name  = "secrets.clusterName"
    value = module.kube_cluster.cluster_name
  }

  set {
    name  = "secrets.logzioRegion"
    value = "uk"
  }
}