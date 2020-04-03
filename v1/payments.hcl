container "payments" {
  image   {
    name = "nicholasjackson/fake-service:vm-v0.9.0"
  }

  network {
    name = "network.azure"
    ip_address = "10.5.0.110"
  }

  env {
    key = "NAME"
    value = "payments"
  }

  env {
      key = "MESSAGE"
      value = "payment successful"
  }
}