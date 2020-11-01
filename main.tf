
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

resource "kubernetes_config_map" "slack_api_url" {
  metadata {
    name = "prometheus-slack-api-url"
  }

  data = {
    "alertmanager.yml": <<EOF
      global: {}
      receivers:
      - name: default-receiver
        slack_configs:
        - api_url: ${var.slack_api_url}
          channel: '#push_alerts'
          send_resolved: true
      route:
        group_interval: 5m
        group_wait: 10s
        receiver: default-receiver
        repeat_interval: 3h
    EOF
  }
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

  set {
    name  = "alertmanager.ingress.hosts"
    value = "{alertmanager${replace(module.kube_cluster.cluster_wildcard_dns, "*", "")}}"
  }

  set {
    name = "alertmanager.configMapOverrideName"
    value = "slack-api-url"
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