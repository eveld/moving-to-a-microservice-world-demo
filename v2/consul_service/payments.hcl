service {
  name = "payments"
  id = "payments-v2"
  port = 9090

  meta {
    version = "2"
  }

  connect { 
    sidecar_service { }
  }
}