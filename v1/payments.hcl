container "payments" {
  image   {
    name = "nicholasjackson/fake-service:vm-v0.9.0"
  }

  # Payments gets a static ip 10.5.0.110 allocated to it.
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

  # The payments service does not have any other upstreams defined.
  # Everything is contained in the monolithic application.
}