container "payments" {
  image   {
    name = "nicholasjackson/fake-service:vm-v0.9.0"
  }

  volume {
    source = "./consul_service/payments.hcl"
    destination = "/config/payments.hcl"
  }

  network {
    name = "network.azure"
    ip_address = "10.5.0.110"
  }

  env {
    key = "CONSUL_SERVER"
    value = "consul.container.shipyard.run"
  }

  env {
    key = "CONSUL_DATACENTER"
    value = "azure"
  }

  env {
    key = "NAME"
    value = "payments"
  }

  env {
      key = "MESSAGE"
      value = "payment successful"
  }

  env {
    key = "SERVICE_ID"
    value = "payments"
  }
}