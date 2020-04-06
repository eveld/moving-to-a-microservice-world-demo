---
id: routing_traffic
title: "Routing traffic to different versions"
sidebar_label: "Routing traffic"
---
Now that we know our new currency microservice works, we want to update the payments service to call out to our microservice instead of the in-process call.
But we do not want all our users to be directed to the new architecture until we are sure that everything works.
What we can do is only route requests that contain certain headers to our new services, by only changing the configuration of the service mesh.

![Header based routing](https://github.com/eveld/hashidays/blob/master/docs/assets/routing_traffic.png?raw=true)

First we want to make sure that all of our users will be routed to the current version of the payments service.
We do this by configuring a `service resolver` to resolve our services, based on metadata.

```go
kind = "service-resolver"
name = "payments"

default_subset = "v1"

subsets = {
  v1 = {
    filter = "Service.Meta.version == 1"
  }
  v2 = {
    filter = "Service.Meta.version == 2"
  }
}
```
```
consul config write v4/consul_service/payments_resolver.hcl
```

Now we can create the new version of the payments service, that makes use of the external currency service.
```
shipyard run v4
```

```go
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
```
```
consul config write v4/consul_service/payments_router.hcl
```