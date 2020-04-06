service {
  name = "payments"
  id = "payments"
  port = 9090

  meta {
    version = "1"
  }

  connect { 
    sidecar_service { }
  }
}