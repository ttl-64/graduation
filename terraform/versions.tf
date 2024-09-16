terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">=0.97.0"
    }
  }
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "terraform-state-yarsvat-diplom"
    region   = "ru-central1-a"
    key      = "terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
