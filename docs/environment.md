---
id: environment
title: "Setting up the environment"
sidebar_label: "Environment"
---
To get started, we will set up the environment that will simulate Azure, containing an HCS (HashiCorp Consul Service) cluster and an AKS (Azure Kubernetes Service) cluster.

...everything offline

This will create:
- a Kubernetes cluster connected to the `azure` network, representing an AKS cluster.
- a Consul cluster connected to the `azure` network, representing an HCS cluster.

![Azure Environment](https://github.com/eveld/hashidays/blob/master/docs/assets/current_setup.png?raw=true)

To create the environment, from the main demo directory run:
```
shipyard run azure
```