container "web-v2" {
  image {
    name = "nicholasjackson/fake-service:vm-v0.9.0"
  }

  volume {
    source      = "./consul_service/web.hcl"
    destination = "/config/web.hcl"
  }

  network { 
    name = "network.azure"
    ip_address = "10.5.0.100"
  }

  env {
    key = "CONSUL_SERVER"
    value = "consul.container.shipyard"
  }

  env {
    key = "CONSUL_DATACENTER"
    value = "azure"
  }

  env {
    key = "NAME"
    value = "web"
  }

  env {
    key = "SERVICE_ID"
    value = "web-v2"
  }

  env {
      key = "UPSTREAM_URIS"
      value = "http://localhost:9091"
  }
}

ingress "web" {
  target = "container.web-v2"
    
  network  {
    name = "network.azure"
  }

  port {
    local  = 9090
    remote = 9090
    host   = 9090
  }
}