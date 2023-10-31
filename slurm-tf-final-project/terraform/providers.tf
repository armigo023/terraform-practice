terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~> 0.80"
    }
    tls = {
      source = "hashicorp/tls"
      version ="~> 4.0.4"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "redacted"
  cloud_id  = "b1g1agtqpfdj81t0tj45"
  folder_id = "b1g186e1hu9ti1gg53rf"
}
