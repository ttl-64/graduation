
output "k8s_pelmenie_cluster_name" {
    description = "Cluster name"
    value = "${yandex_kubernetes_cluster.k8s_pelmenie_cluster.name}"
}

output "k8s_pelmenie_cluster_id" {
    description = "Cluster ID"
    value = "${yandex_kubernetes_cluster.k8s_pelmenie_cluster.id}"
}

output "k8s_pelmenie_cluster_cmd" {
  description = <<EOF
    Kubernetes cluster public IP address.
    Use the following command to download kube config and start working with Yandex Managed Kubernetes cluster:
    `$ yc managed-kubernetes cluster get-credentials --id <cluster_id> --external`
    This command will automatically add kube config for your user; after that, you will be able to test it with the
    `kubectl get cluster-info` command.
  EOF
  value       = var.public_access ? "yc managed-kubernetes cluster get-credentials --id ${yandex_kubernetes_cluster.k8s_pelmenie_cluster.id} --external" : null
}
output "yandex_dns_zone" {
    description = "DNS Zone registered in Yandex Cloud DNS"
    value = "${yandex_dns_zone.zone1.zone}"
}