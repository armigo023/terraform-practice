data "yandex_compute_image" "this" {
  name = format("%s-%s",var.vm_image_name,var.vm_image_tag)
}

resource "yandex_compute_instance_group" "this" {
  name        = "${local.preffix}project-instance-group"
  service_account_id  = "${yandex_iam_service_account.this.id}"
  
  instance_template {
    labels = var.labels
    platform_id = "standard-v1"
 
    resources {
      cores  = var.resources.cpu
      memory = var.resources.memory
    }

    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.this.id
        size = var.resources.disk
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.this.id}"
      subnet_ids = [for v in yandex_vpc_subnet.this : v.id]
      nat = true
    }

    metadata = {
      ssh-keys = "centos:${var.public_ssh_key_path != "" ? var.public_ssh_key_path : tls_private_key.project-ssh-key[0].public_key_openssh}"
    }
  }

  scale_policy {
    fixed_scale {
      size = var.vm_count
    }
  }

  allocation_policy {
    zones = var.az
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }

  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "load balancer target group"
  }

  depends_on = [yandex_resourcemanager_folder_iam_binding.this]
}
