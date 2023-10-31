resource "yandex_alb_target_group" "this" {
  name      = "${local.preffix}project-alb-target-group"

  labels = var.labels

  dynamic "target" {
    for_each = yandex_compute_instance_group.this.instances
    content {
      subnet_id = target.value.network_interface.0.subnet_id
      ip_address   = target.value.network_interface.0.ip_address
    }
  }
}

resource "yandex_alb_backend_group" "this" {
  name      = "${local.preffix}alb-nginx-backend-group"

  http_backend {
    name = "${local.preffix}nginx-http-backend"
    weight = 1
    port = 80
    target_group_ids = ["${yandex_alb_target_group.this.id}"]
    load_balancing_config {
      panic_threshold = 50
    }    
    healthcheck {
      timeout = "1s"
      interval = "1s"
      http_healthcheck {
        path  = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "this" {
  name      = "${local.preffix}nginx-http-router"
  labels = var.labels
}

resource "yandex_alb_virtual_host" "this" {
  name           = "${local.preffix}nginx-vhost"
  http_router_id = yandex_alb_http_router.this.id
  route {
    name = "${local.preffix}nginx-route"
    http_route {
      http_route_action {
        backend_group_id = "${yandex_alb_backend_group.this.id}"
        timeout          = "60s"
      }
    }
  }
}   

resource "yandex_alb_load_balancer" "this" {
  name = "${local.preffix}project-load-balancer"

  labels = var.labels
  
  network_id = "${yandex_vpc_network.this.id}"
  
  allocation_policy {
    dynamic "location" {
      for_each = yandex_vpc_subnet.this
      content { 
        zone_id   = location.key
        subnet_id = location.value.id
      }
    }
  }

  listener {
    name = "${local.preffix}project-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 8080 ]
    }    
    http {
      handler {
        http_router_id = yandex_alb_http_router.this.id
      }
    }
  }

  log_options {
    discard_rule {
      http_code_intervals = ["HTTP_2XX"]
      discard_percent = 75
    }
  }
}
