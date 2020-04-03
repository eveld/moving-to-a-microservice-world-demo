service {
  name = "payments"
  id = "payments"
  port = 9090

  meta {
    version = "2"
  }

  connect { 
    sidecar_service { }
  }
}