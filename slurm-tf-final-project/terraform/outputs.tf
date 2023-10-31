output "instances_ext_ip_addr" {
  description = "The external IP address of the instance"
  value = yandex_compute_instance_group.this.instances[*].network_interface.0.nat_ip_address
}

output "project-alb-ext-ip" {
  description = "The external IP address of the network load balancer"
  value = tolist(tolist(tolist(yandex_alb_load_balancer.this.listener).0.endpoint).0.address).0.external_ipv4_address
}

output "private_ssh_key" {
  description = "The private part of new generated ssh key"
  value = var.public_ssh_key_path !="" ? "" : tls_private_key.project-ssh-key[0].private_key_openssh 
  sensitive = true
}
