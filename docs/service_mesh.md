---
id: service_mesh
title: "Using Consul Service Mesh"
sidebar_label: "Service Mesh"
--- 
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