output "kubeconfig" {
    value = scaleway_k8s_cluster_beta.testing.kubeconfig
}

output "cluster_name" {
    value = scaleway_k8s_cluster_beta.testing.name
}

output "cluster_wildcard_dns" {
    value = scaleway_k8s_cluster_beta.testing.wildcard_dns
}
