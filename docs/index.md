---
id: index
title: "Moving to a Microservice World: Leveraging Consul on Azure"
sidebar_label: "Index"
---
This demo will guide you through migrating an application from a monolithic application running on a virtual machine to microservices running on Kubernetes, using Consul Service Mesh.

![AKS and HCS](https://github.com/eveld/hashidays/blob/master/docs/assets/logos.png?raw=true)

When you started this demo Shipyard created several resources for you:
- a public `WAN` network with a subnet of 192.168.0.0/16, representing the public internet.
- a private networks called `azure` with a subnet of 10.5.0.0/16, representing a virtual network on Azure.

The rest of the environment you will create in the next steps.