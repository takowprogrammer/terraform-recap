resource "docker_image" "app" {
  name         = var.image_name
  keep_locally = false
}

resource "docker_container" "app" {
  name    = var.container_name
  image   = docker_image.app.image_id
  command = length(var.command) > 0 ? var.command : null
  env     = var.environment_vars

  ports {
    internal = var.internal_port
    external = var.external_port
  }

  dynamic "networks_advanced" {
    for_each = var.network_name != "" ? [1] : []
    content {
      name = var.network_name
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
