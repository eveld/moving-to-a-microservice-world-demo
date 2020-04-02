data_dir = "/tmp/"
log_level = "DEBUG"

datacenter = "azure"
primary_datacenter = "azure"

server = true

bootstrap_expect = 1
ui = true

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

advertise_addr = "10.5.0.200"
advertise_addr_wan = "192.168.0.200"

ports {
  grpc = 8502
}

connect {
  enabled = true
}

config_entries {
  bootstrap 
    {
      kind = "proxy-defaults"
      name = "global"

      config {
        protocol = "http"
      }

      mesh_gateway = {
        mode = "local"
      }
    }
}