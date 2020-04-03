k8s_config "web" {
    cluster = "k8s_cluster.aks"
	paths = ["./k8s_config"]
	wait_until_ready = true

  health_check {
    timeout = "60s"
    pods = ["service=web"]
  }
}

ingress "web" {
  target = "k8s_cluster.aks"
  service = "svc/web"
    
  network  {
    name = "network.azure"
  }

  port {
    local  = 9090
    remote = 9090
    host   = 9090
  }
}