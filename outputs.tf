output "grafana_url" {
    value = "grafana${replace(module.kube_cluster.cluster_wildcard_dns, "*", "")}"
}

output "prometheus_url" {
    value = "prometheus${replace(module.kube_cluster.cluster_wildcard_dns, "*", "")}"
}
