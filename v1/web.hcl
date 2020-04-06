container "web" {
  image {
    name = "nicholasjackson/fake-service:vm-v0.9.0"
  }

  network { 
    name = "network.azure"
    ip_address = "10.5.0.100"
  }

  env {
    key = "NAME"
    value = "web"
  }

  env {
      key = "MESSAGE"
      value = "ok"
  }

  env {
      key = "UPSTREAM_URIS"
      value = "http://10.5.0.110:9090"
  }
}

ingress "web" {
  target = "container.web"
    
  network  {
    name = "network.azure"
  }

  port {
    local  = 9090
    remote = 9090
    host   = 9090
    open_in_browser = "/ui
  }
}