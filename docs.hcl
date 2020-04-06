docs "docs" {
  path  = "./docs"
  port  = 8080
  open_in_browser = true

  index_title = "Contents"
  index_pages = [
      "index",
      "environment",
      "initial_situation",
      "service_mesh",
      "first_microservice",
      "routing_traffic",
      "canary_release"
  ]

  network {
    name = "network.azure"
  }
}