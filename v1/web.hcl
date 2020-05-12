container "web" {
  image {
    name = "nicholasjackson/fake-service:vm-v0.9.0"
  }

  # Web gets a static ip 10.5.0.100 allocated to it.
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

  # Web calls the payments service directly on ip 10.5.0.110 and port 9090.
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

  # Web is exposed to the localhost on port 9090.
  port {
    local  = 9090
    remote = 9090
    host   = 9090
    open_in_browser = "/ui"
  }
}