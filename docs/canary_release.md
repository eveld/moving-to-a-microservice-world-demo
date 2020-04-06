---
id: canary_release
title: "Migrating to the new release"
sidebar_label: "Canary Release"
---
Now that the new version of the payments service has been tested by the developers and perhaps a test group of users, traffic can slowly be directed to that version.

## Splitting traffic

To start off, you need to create a traffic splitter, that will take traffic and split them over the available subsets.
In this case all traffic (100%) will be sent to the current version, located in subset `v1`. No traffic (0%) will be sent to the new version.

![100% on current version](assets/traffic_split_100_0.png?raw=true)

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

Write this configuration to the central config.

```
consul config write v5/consul_service/payments_splitter_100_0.hcl
```

When hitting the root `/` endpoint, all requests are handled by the current version of the payments service.

## 50/50

Now the percentages on the v1 subset can be decreased (50%) and on the v2 subset can be increased (50%). This will send the given percentages of traffic to their corresponding endpoints.

![50% on current version and 50% on new version](assets/traffic_split_50_50.png?raw=true)

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

Once the configuration is applied, you should see 50% of the requests going to the current version and 50% to the new version.

```
consul config write v5/consul_service/payments_splitter_50_50.hcl
```

## Migrating

If everything went well and no errors were seen, all traffic can be sent to the new version.

![100% on new version](assets/traffic_split_0_100.png?raw=true)

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

Now all requests will hit the new payments service.

```
consul config write v5/consul_service/payments_splitter_0_100.hcl
```

If after a certain time the new service has performed without any issues, the old version can be removed and more features can be split off in the same way.
You have now migrated to a microservices architecture without disrupting your end users.

