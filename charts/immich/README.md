# Immich

## How to use

Add repository by running:

```bash
helm repo add k8s-at-our-home https://k8s-at-our-homes.github.io/helm-charts/
helm install immich k8s-at-our-home/immich
```

Or get the chart from ghcr.io:

```bash
helm install immich oci://ghcr.io/k8s-at-our-homes/helm-charts
```

---

## Redis Configuration

Redis is configured via the `redis` values section. By default, it runs in standalone mode without authentication:

```yaml
redis:
  enabled: true
  replicas: 1
  auth: false
```

The chart uses the [DandyDeveloper redis-ha](https://github.com/DandyDeveloper/charts/tree/master/charts/redis-ha) chart in standalone mode for simplicity and reliability.
