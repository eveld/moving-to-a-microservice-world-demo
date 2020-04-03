docs "docs" {
  path  = "./docs"
  port  = 8080

  index_title = "HashiDays"
  index_pages = [ 
      "index"
  ]

  network {
    name = "network.azure"
  }
}