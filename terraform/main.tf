# Создаем сервисный аккаунт для k8s и накидываем различные роли
resource "yandex_iam_service_account" "service_account" {
 name        = var.service_account_name
 folder_id   = var.folder_id
}

locals {
  service_account_id = try(yandex_iam_service_account.service_account.id, var.service_account_id)
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
 # Сервисному аккаунту назначается роль "editor".
 folder_id = var.folder_id
 role      = "editor"
 member    = "serviceAccount:${local.service_account_id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
 # Сервисному аккаунту назначается роль "container-registry.images.puller".
 folder_id = var.folder_id
 role      = "container-registry.images.puller"
 member    = "serviceAccount:${local.service_account_id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-editor" {
 # Сервисному аккаунту назначается роль "container-registry.images.puller".
 folder_id = var.folder_id
 role      = "k8s.editor"
 member    = "serviceAccount:${local.service_account_id}"
}

resource "yandex_resourcemanager_folder_iam_member" "dns-editor" {
 # Сервисному аккаунту назначается роль "dns-editor".
 folder_id = var.folder_id
 role      = "dns.editor"
 member    = "serviceAccount:${local.service_account_id}"
}

resource "yandex_resourcemanager_folder_iam_member" "load-balancer" {
 # Сервисному аккаунту назначается роль "load-balancer.admin".
 folder_id = var.folder_id
 role      = "load-balancer.admin"
 member    = "serviceAccount:${local.service_account_id}"
}

######################################################

# Создаём сетку и выбираем подсеть для k8s-кластера
resource "yandex_vpc_network" "k8s_net" {
  name = "k8s_net"
}

resource "yandex_vpc_subnet" "a" {
  network_id = yandex_vpc_network.k8s_net.id

  name = "a"
  zone = var.zone

  v4_cidr_blocks = ["10.1.0.0/16"]
}
######################################################

# Создаём K8s-кластер на зоне
resource "yandex_kubernetes_cluster" "k8s_pelmenie_cluster" {
  name        = var.k8s_cluster_name
  description = "k8s zonal cluster for graduation work"
  folder_id   =  var.folder_id

  network_id = "${yandex_vpc_network.k8s_net.id}"

  master {
    version = var.k8s_version
    zonal {
      zone      = "${yandex_vpc_subnet.a.zone}"
      subnet_id = "${yandex_vpc_subnet.a.id}"
    }

    public_ip = var.public_access

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        day        = "monday"
        start_time = "23:00"
        duration   = "3h"
      }
    }

    #default settings for yandex monitoring and logging of cluster and working nodes
    master_logging {
      enabled = true
      folder_id = var.folder_id
      kube_apiserver_enabled = true
      cluster_autoscaler_enabled = true
      events_enabled = true
      audit_enabled = true
    }
  }

  service_account_id      = "${local.service_account_id}"
  node_service_account_id = "${local.service_account_id}"

  release_channel = var.k8s_release_channel
  network_policy_provider = var.k8s_network_provider

  depends_on = [
    yandex_iam_service_account.service_account,
    yandex_resourcemanager_folder_iam_member.k8s-editor
  ]
}
#################################################################

# Создаём рабочих лошадок 
resource "yandex_kubernetes_node_group" "group" {
  cluster_id  = yandex_kubernetes_cluster.k8s_pelmenie_cluster.id
  name        = var.k8s_group_name
  description = "Working horses"
  version     = var.k8s_version

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat                = var.node_network_nat
      subnet_ids         = [yandex_vpc_subnet.a.id]
    }

    scheduling_policy {
      preemptible = var.node_scheduling_policy
    }

    container_runtime {
      type = var.node_container_runtime
    }

    resources {
      memory = var.node_ram_size
      cores  = var.node_cpu_number
      core_fraction = var.node_fraction_percent
    }

    boot_disk {
      type = var.node_disk_type
      size = var.node_disk_size
    }

  }

  scale_policy {
    fixed_scale {
      size = var.nodes_scale_size
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "23:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "23:00"
      duration   = "3h"
    }
  }
}

######################################
# Работаем с публичными DNS-записями

resource "yandex_dns_zone" "zone1" {
  name = var.dns_zone_name
  zone = var.dns_zone
  public = var.dns_public_access
}