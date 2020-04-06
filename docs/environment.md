---
id: environment
title: "Setting up the environment"
sidebar_label: "Environment"
---
To make this demo portable, we are simulating cloud resources on the local machine using Shipyard. The interfaces to the resources are all still the same, so all learned lessons here will apply to the actual cloud environment.

First, we will set up the environment that will simulate Azure, containing an HCS (HashiCorp Consul Service) cluster and an AKS (Azure Kubernetes Service) cluster.

This will create:
- a Kubernetes cluster connected to the `azure` network, representing an AKS cluster.
- a Consul cluster connected to the `azure` network, representing an HCS cluster.

![Azure Environment](https://github.com/eveld/hashidays/blob/master/docs/assets/current_setup.png?raw=true)

To create the environment, from the main demo directory run:
```
shipyard run azure
```

Once the resources are created, the UI of Consul and Kubernetes should open automatically in your browser.

![Consul UI](https://github.com/eveld/hashidays/blob/master/docs/assets/consul_ui.png?raw=true)

Next we will create the applications.