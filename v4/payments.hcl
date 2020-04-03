k8s_config "payments" {
    cluster = "k8s_cluster.aks"
	paths = ["./k8s_config"]
	wait_until_ready = true

  health_check {
    timeout = "60s"
    pods = ["service=payments-v2"]
  }
}