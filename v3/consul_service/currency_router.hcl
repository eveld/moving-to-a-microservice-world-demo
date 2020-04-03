kind = "service-router"
name = "payments"
routes = [
  {
    match {
      http {
        path_prefix = "/currency"
      }
    }

    destination {
      service = "currency"
    }
  },
]