---
id: first_microservice
title: "Creating the first microservice"
sidebar_label: "First Microservice"
---
Now that you have the applications connected with a service mesh, you can start splitting off pieces of functionality into microservices.
To start, take an isolated piece of functionality (the currency converter service) and turn it into a microservice.

![Currency microservice](assets/first_microservice.png?raw=true)

## Create the currency service

Lets run the new `currency` microservice on Kubernetes.

```
shipyard run v3
```

## Path based routing

To be sure that the currency microservice works as expected, expose it on a separate path. This way you can call it and test that everything functions as intended.

This will route all traffic going to the payments service on path `/currency` to the new currency microservice instead.
All other traffic should still go to the payments service, so it does not interrupt the service for the end users.

```
consul config write v3/consul_service/currency_router.hcl
```