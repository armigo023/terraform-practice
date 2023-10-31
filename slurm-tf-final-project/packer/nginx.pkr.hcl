packer {
  required_plugins {
    yandex = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/yandex"
    }
  }
}

variable "image_tag" {
  type = string
  default = "0"
}

source "yandex" "nginx_custom_image" {
  token = "redacted"
  folder_id = "b1g186e1hu9ti1gg53rf"
  image_name = "nginx-${var.image_tag}"
  image_family = "centos7-nginx"
  source_image_family = "centos-7"
  use_ipv4_nat = true
  disk_type = "network-ssd"
  ssh_username = "centos"
}

build {
  sources = ["source.yandex.nginx_custom_image"]

  provisioner "shell" {
    inline = ["echo 'Upgrading packages'","sudo yum update -y","echo 'Done'"]
  }

  provisioner "ansible" {
    playbook_file = "./ansible/playbook.yml"
    extra_arguments = ["-v", "--scp-extra-args", "'-O'", "--ssh-extra-args", "-o IdentitiesOnly=yes -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa"]
  }
}
