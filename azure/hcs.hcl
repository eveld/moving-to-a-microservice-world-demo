container "consul" {
  image {
    name = "consul:1.7.2"
  }
  
  command = ["consul", "agent", "-config-file=/config/server.hcl"]

  volume {
    source      = "./consul_config"
    destination = "/config"
  }

  network { 
    name = "network.azure"
    ip_address = "10.5.0.200"
  }

  network { 
    name = "network.wan"
    ip_address = "192.168.0.200"
  }
}

ingress "consul" {
  target = "container.consul"

  network {
    name = "network.azure"
  }

  port {
    local  = 8500
    remote = 8500
    host   = 8500
    open_in_browser = true
  }
}
