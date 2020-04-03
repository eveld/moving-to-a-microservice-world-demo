We will need to set up the environment that will simulate Azure, containing an HCS cluster and a AKS cluster.


```
shipyard run azure
```

Now that we have our cloud environment up and running, we can start to add our applications.
In the initial situation we have 2 VMs running, one containing an inbound proxy called "web" and the other one containing our "payments" monolith.
The applications are configured statically, with web pointing directly to the ip address of payments.

To spin up the two VMs we can create the resources located in the `v1` directory.

```
shipyard run v1
```

```
shipyard destroy v1
shipyard run v2

consul config write v2/consul_service/payments_defaults.hcl
consul config write v2/consul_service/web_defaults.hcl
```

```
shipyard run v3

consul config write v3/currency_router.hcl
```

```
shipyard run v4

consul config write v4/payments_resolver.hcl
```