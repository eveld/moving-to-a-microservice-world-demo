---
id: routing_traffic
title: "Routing traffic to different versions"
sidebar_label: "Routing traffic"
---
Now that you know that the new currency microservice works, the next step is to update the payments service to call out to the microservice instead of an in-process call.
But you do not want all of the users to be directed to the new architecture until you are sure that everything works.
What you can do is only route requests that contain certain headers to the new services, by only changing the configuration of the service mesh.

![Header based routing](assets/routing_traffic.png?raw=true)

## Resolve different versions
First you want to make sure that all of the users will be routed to the current version of the payments service.
You do this by configuring a `service resolver` to resolve our services, based on metadata.

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

Like before with the service defaults, write this configuration to the central config.

```
consul config write v4/consul_service/payments_resolver.hcl
```

## Launch payments service v2

Now you can create the a version of the payments service, one that makes use of the external currency service.

```
shipyard run v4
```

## Route traffic based on headers

With the new version of the payments service deployed, you can now start directing very specific requests to it that contain certain headers.
In this case the configuration routes all traffic that has a header of `X-Group` set to `dev` to the new version of the payments service.

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

After writing the configuration to the central config, requests containing a header of `X-Group: dev` should show a longer call chain, containing the added currency service.

```
consul config write v4/consul_service/payments_router.hcl
```

## Test the new service

You can test this by hitting the endpoint with curl.

```
curl -H 'X-Group:dev' http://web.container.shipyard.run
```