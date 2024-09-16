variable "cloud_id" {
  description = "Cloud ID"
  type        = string
  default     = "<>"
}

variable "folder_id" {
  description = "Folder ID"
  type        = string
  default     = "<>"
}
variable "zone" {
  description = "Zone"
  type        = string
  default     = "<>"
}

variable "service_account_name" {
  description = <<-EOF
  Name of service account to create to be used for provisioning Compute Cloud
  and VPC resources for Kubernetes cluster.

  `service_account_name` is ignored if `service_account_id` is set.
  EOF

  type = string

  default = null
}
variable "service_account_id" {
  description = <<-EOF
  ID of existing service account to be used for provisioning Compute Cloud
  and VPC resources for Kubernetes cluster. Selected service account should have
  edit role on the folder where the Kubernetes cluster will be located and on the
  folder where selected network resides.
  EOF

  type = string

  default = null
}

variable "public_access" {
  description = "Public or private Kubernetes cluster"
  type        = bool
  default     = true
}
variable "dns_zone_name" {
  description = "Defines DNS zone name"
  type = string
  default = "example"
}
variable "dns_zone" {
  description = "Defines zone domain. '.' - the dot should be at the end of string"
  type = string
  default = "example.com."
}
variable "dns_public_access" {
  description = "Public or private dns zone"
  type        = bool
  default     = true
}

variable "nodes_scale_size" {
  description = "Number of working nodes in group"
  type = number
  default = 1
}

variable "node_disk_type" {
  description = "boot disk type. The cheapest - network-hdd"
  type = string
  default = "network-hdd"
}
variable "node_disk_size" {
  description = "disk volume in GB"
  type = number
  default = 30
}

variable "node_ram_size" {
  description = "RAM in GB"
  type = number
  default = 4
}

variable "node_cpu_number" {
  description = "Number of vCPU"
  type = number
  default = 2
}

variable "node_fraction_percent" {
  description = "Переподписка в процентах 1-4, 1-2, 1-1"
  type = number
  default = 20
}

variable "node_container_runtime" {
  description = "Type of runtime on node"
  type = string
  default = "containerd"
}

variable "node_scheduling_policy" {
  description = "Прерываемая или нет. Самый дешевый вариант - прерываемая"
  type        = bool
  default     = true
}

variable "node_network_nat" {
  description = "NAT - bool"
  type = bool
  default = true
}

variable "k8s_group_name" {
  description = "Name of node group"
  type = string
  default = "default-group"
}

variable "k8s_version" {
  description = "Version for k8s cluster and node group"
  type = string
  default = "1.28"
}

variable "k8s_release_channel" {
  description = "Release Channel of your k8s cluster"
  type = string
  default = "STABLE"
}

variable "k8s_network_provider" {
  description = "K8s Network Provider"
  type = string
  default = "CALICO"
}

variable "k8s_cluster_name" {
  description = "K8s Cluster Name"
  type = string
  default = "default"
}