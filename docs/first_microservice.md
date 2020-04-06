---
id: first_microservice
title: "Creating our first microservice"
sidebar_label: "First Microservice"
---
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