---
id: service_mesh
title: "Using Consul Service Mesh"
sidebar_label: "Service Mesh"
--- 
Now that you have a working application, lets start with the migration.

You will replace the initial setup with a service-meshed version of the setup. This allows the services to easily discover each other, and gives the additional benefit that all the traffic between the services is encrypted through mTLS.

![Consul Service Mesh](assets/service_mesh.png?raw=true)

Instead of the services connecting directly to each other, they will instead connect to a local sidecar proxy. This proxy then securely sends all requests to the sidecar proxy of the other service, which forwards it to the destination service. The applications do not need to know where the other service is located, the service mesh handles all this for us.

## Remove static setup

First, remove the initial setup.

```
shipyard destroy v1
```

## Create service mesh

And replace it with the setup shown above, that uses Consul Service Mesh.

```
shipyard run v2
```

## L7 configuration

Since the web service is a proxy such as NGINX or HAProxy, this can easily be containerised and moved to Kubernetes already. The payments service however is a big monolithic application and will take some time to cut up into smaller services. So it is best to keep it in one piece on a VM for now.

You want to tell the service mesh that the applications speak HTTP, so that you can use the L7 features such as routing and traffic splitting later on.
With the following configurations you set the protocol to HTTP in the service defaults for the `payments` service.

```go
Kind = "service-defaults"
Name = "payments"
Protocol = "http"
```

To effectuate the configuration, you need to write it to the central config.

```
consul config write v2/consul_service/payments_defaults.hcl
```

Because the `web` service is running on Kubernetes with the Connect Injector enabled, we can set the protocol when creating the deployment by setting the `"consul.hashicorp.com/connect-service-protocol": "http"` annotation.