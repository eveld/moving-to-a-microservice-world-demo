container "payments" {
    # We are running payments as a fake virtual machine in a "fat" container.
    image   {
        name = "nicholasjackson/fake-service:vm-v0.9.0"
    }

    # We mount the service file so it automatically gets registered by the container.
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
        value = "hcs.container.shipyard.run"
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

# we register the service defaults for the payments service, 
# so we can make use of the L7 features of the service mesh later.
exec_remote "payments_defaults" {
    network {
        name = "network.azure"
    }

    image {
        name = "shipyardrun/tools:beta"
    }

    volume {
        source = "consul_service/payments_defaults.hcl"
        destination = "/config/payments_defaults.hcl"
    }

    env {
        key = "CONSUL_HTTP_ADDR"
        value = "hcs.container.shipyard.run:8500"
    }

    cmd = "consul"
    args = ["config", "write", "/config/payments_defaults.hcl"]
}