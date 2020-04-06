---
id: canary_release
title: "Migrating to the new release"
sidebar_label: "Canary Release"
---
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