service {
  name = "payments"
  id = "payments-v3"
  port = 9090

  meta {
    version = "3"
  }

  connect { 
    sidecar_service { }
  }
}