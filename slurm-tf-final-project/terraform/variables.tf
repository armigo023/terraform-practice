variable "vm_image_name" {
  type        = string
  description = "Name of the image for the virtual machine"
}

variable "vm_image_tag" {
  type        = string
  description = "Tag of the image for the virtual machine"
}

variable "vm_count" {
  type        = number
  description = "Number of instances of virtual machine"
  default = 2
}

variable "cidr_blocks" {
  type        = list(list(string))
  description = "List of IPv4 cidr blocks for subnet"
}

variable "labels" {
  type        = map(string)
  description = "Labels to add to resources"
}

variable "resources" {
  type        = object({
    cpu = number,
    memory = number,
    disk = number
  }) 
}

variable "public_ssh_key_path" {
  type = string
  description = "Public SSH key"
  default = ""
}

variable "az" {
  type = list(string)
  description = "Availability Zone for the resource"
  default = [
    "ru-central1-a",
    "ru-central1-b",
    "ru-central1-c"
  ]
}
