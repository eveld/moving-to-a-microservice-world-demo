kind = "service-resolver"
name = "payments"

default_subset = "v2"

subsets = {
  v2 = {
    filter = "Service.Meta.version == 2"
  }
  v3 = {
    filter = "Service.Meta.version == 3"
  }
}