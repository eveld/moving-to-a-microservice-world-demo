service {
  name = "web"
  id = "web-v2"
  port = 9090

  meta {
    version = "2"
  }

  connect { 
    sidecar_service { 
      proxy {
        upstreams {
          destination_name = "payments"
          local_bind_address = "127.0.0.1"
          local_bind_port = 9091
        }
      }
    }
  }
}