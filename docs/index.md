---
id: index
title: "Moving to a Microservice World: Leveraging Consul on Azure"
---

This demo will guide you through migrating an application from a monolith to microservices, using Consul Service Mesh.

# Set up the environment
To get started, we will set up the environment that will simulate Azure, containing an HCS (HashiCorp Consul Service) cluster and an AKS (Azure Kubernetes Service) cluster.

```
shipyard run azure
```

# Initial situation

Now that we have our "cloud" environment up and running, we can start to add our applications.
In the initial situation we have 2 "VMs" running, one containing an inbound proxy called "web" and the other one containing our "payments" monolith.
The applications are configured statically, with web pointing directly to the ip address of payments.

Because we want to be able to run this demo entirely on our local machine, we will be simulating VMs with fat containers.
These Alpine containers will have 3 processes running, managed by Supervisor:
- Application binary.
- Consul agent, configured as a client.
- Envoy sidecar proxy for the application.

![Containers as VMs](https://github.com/eveld/hashidays/blob/master/docs/assets/fake_vm.png?raw=true)


To spin up the two VMs we can create the resources located in the `v1` directory.

![Initial Setup](https://github.com/eveld/hashidays/blob/master/docs/assets/initial_setup.png?raw=true)

```
shipyard run v1
```

# Consul Service Mesh 
Remove the initial setup and replace it with a setup that uses Consul Service Mesh to do service discovery.
This gives the additional benefit that all the traffic between our services is now encrypted through mTLS.

![Consul Service Mesh](https://github.com/eveld/hashidays/blob/master/docs/assets/service_mesh.png?raw=true)

```
shipyard destroy v1
```
```
shipyard run v2
```

Set the protocol to HTTP in the service defaults for the payments service and the web service.
```go
Kind = "service-defaults"
Name = "payments"
Protocol = "http"
```
```
consul config write v2/consul_service/payments_defaults.hcl
```

```go
Kind = "service-defaults"
Name = "web"
Protocol = "http"
```
```
consul config write v2/consul_service/web_defaults.hcl
```

# First Microservice
Now that we have our applications connected with a service mesh, we can start splitting off pieces of functionality into microservices.
To start, we will take an isolated piece of functionality (the currency converter service) and turn it into a microservice.

![Currency microservice](https://github.com/eveld/hashidays/blob/master/docs/assets/first_microservice.png?raw=true)

```
shipyard run v3
```

Set the protocol to HTTP in the service defaults for the currency service, so we can make use of the L7 capabilities of Envoy.
```go
Kind = "service-defaults"
Name = "currency"
Protocol = "http"
```
```
consul config write v3/consul_service/currency_defaults.hcl
```

To be sure that our currency microservice works as expected, we will expose it on a separate path. This way we can call it and test that everything functions as intended.

We will route all traffic going to the payments service on path `/currency` to the new currency microservice instead.
All other traffic should still go to the payments service, so we don't interrupt the service for our users.

```
consul config write v3/consul_service/currency_router.hcl
```

# Routing traffic
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

# Release Canary

```go
kind = "service-splitter",
name = "payments"

splits = [
  {
    weight = 100,
    service_subset = "v1"
  },
  {
    weight = 0,
    service_subset = "v2"
  }
]
```
```
consul config write v5/consul_service/payments_splitter_100_0.hcl
```

![100% on current version](https://github.com/eveld/hashidays/blob/master/docs/assets/traffic_split_100_0.png?raw=true)

```go
kind = "service-splitter",
name = "payments"

splits = [
  {
    weight = 50,
    service_subset = "v1"
  },
  {
    weight = 50,
    service_subset = "v2"
  }
]
```
```
consul config write v5/consul_service/payments_splitter_50_50.hcl
```

![50% on current version and 50% on new version](https://github.com/eveld/hashidays/blob/master/docs/assets/traffic_split_50_50.png?raw=true)

```go
kind = "service-splitter",
name = "payments"

splits = [
  {
    weight = 0,
    service_subset = "v1"
  },
  {
    weight = 100,
    service_subset = "v2"
  }
]
```
```
consul config write v5/consul_service/payments_splitter_0_100.hcl
```

![100% on new version](https://github.com/eveld/hashidays/blob/master/docs/assets/traffic_split_0_100.png?raw=true)