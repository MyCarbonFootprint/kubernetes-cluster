output "grafana_url" {
    value = "grafana${replace(module.kube_cluster.cluster_wildcard_dns, "*", "")}"
}

output "prometheus_url" {
    value = "prometheus${replace(module.kube_cluster.cluster_wildcard_dns, "*", "")}"
}

output "alertmanager_url" {
    value = "alertmanager${replace(module.kube_cluster.cluster_wildcard_dns, "*", "")}"
}

output "kube_host" {
    value = module.kube_cluster.kubeconfig[0].host
    sensitive   = true
}

output "kube_token" {
    value = module.kube_cluster.kubeconfig[0].token
    sensitive   = true
}
