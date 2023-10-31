vm_image_name = "nginx"

vm_image_tag = "1"

vm_count = 3

labels = {
  "project" = "slurm"
  "env" = "lab"
}

cidr_blocks = [
  ["10.10.0.0/24","10.10.1.0/24"],
  ["10.10.2.0/24","10.10.3.0/24"],
  ["10.10.4.0/24","10.10.5.0/24"]
]

resources = {
  cpu = 4
  memory = 8
  disk = 20
}

public_ssh_key_path = ""
