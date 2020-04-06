kind = "service-router"
name = "payments"
routes = [
  {
    match {
      http {
        header = [
          {
            name  = "X-Group"
            exact = "dev"
          },
        ]
      }
    }

    destination {
      service = "payments"
      service_subset = "v2"
    }
  },
]