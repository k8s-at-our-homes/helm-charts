
# Dawarich Helm Chart

## Usage

Add the Helm repository and install Dawarich:

```bash
helm repo add k8s-at-our-home https://k8s-at-our-homes.github.io/helm-charts/
helm install dawarich k8s-at-our-home/dawarich
```

Or install directly from ghcr.io:

```bash
helm install dawarich oci://ghcr.io/k8s-at-our-homes/helm-charts
```

---

### Redis Configuration

Redis is configured via the `redis` values section. By default, it runs in standalone mode without authentication:

```yaml
redis:
  enabled: true
  replicas: 1
  auth: false
```

---

## Photon Reverse Geocoding

Photon Reverse Geocoding translates coordinates (latitude/longitude) into real-world locations (country, city, street, etc). This process sends your coordinates to a Photon host, which may have privacy implications. To protect your data, you can deploy a local Photon instance using this chart.

### 1. Smart Load Balancer (Default: Enabled)

When `photon.enabled=true`, reverse geocoding is enabled and a proxy intelligently load-balances requests between multiple Photon hosts.

**Public Photon Instances (queried in round-robin):**

If a self-hosted Photon instance is enabled, it is always queried first. If it cannot resolve the location, a public instance is used as fallback. A default set of public hosts is provided and can be overwritten by setting `photon.gateway.hosts`.

### 2. Self-hosted Photon Instance (Default: Enabled)

When `photon.deploy=true`, a local Photon instance is deployed for maximum privacy.

- **Privacy:** Your location data stays private.
- **Resource Usage:** Photon uses OpenSearch, which is memory-intensive (recommended: 64GiB RAM for the full worldwide dataset).
- **Dataset Limiting:** You can restrict the dataset to your home country to reduce resource usage. Note: The local instance will not resolve locations outside the selected dataset.

**Combining Local and Public Instances:**
Deploying a smaller local Photon instance with public load balancing provides privacy for your home location, while still allowing geocoding for coordinates outside your country.

#### Example Configuration

```yaml
photon:
  enabled: true
  deploy: true
  config:
    country: "NL"  # Limit local data to Netherlands
```
