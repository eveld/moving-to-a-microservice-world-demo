k8s_cluster "aks" {
  driver  = "k3s"
  version = "v1.0.0"

  nodes = 1

  network {
    name = "network.azure"
  }

  network {
    name = "network.wan"
  }
}

helm "consul" {
  cluster = "k8s_cluster.aks"

  chart = "./helm/consul-helm-0.16.2"
  values = "./helm/consul-values.yaml"
}