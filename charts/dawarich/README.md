
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

## Configuration

### Rails Environment and Production Settings

By default, the chart is configured for production deployments with the following settings:

```yaml
config:
  railsEnv: production        # Rails environment (development or production)
  railsLogToStdout: true     # Log to stdout for container logging
  secretKeyBase: ""          # Leave empty to auto-generate, or set for production
```

**Important for Production:**
- `railsEnv`: Set to `production` (default) for production deployments to enable asset caching, security features, and optimal performance
- `secretKeyBase`: For production use, it's recommended to set a strong, random secret key base (128+ characters). If left empty, a random one will be generated and stored in a Kubernetes secret
- `railsLogToStdout`: Enabled by default to ensure logs are captured by Kubernetes

**Generating a secret key base:**
```bash
openssl rand -hex 64
```

### Persistent Storage

Application data persistence is enabled by default:

```yaml
app:
  persistence:
    enabled: true              # Enable persistent storage
    size: 5Gi                  # Storage size
    # storageClass: ""         # Optional: specify storage class
    # existingClaim: ""        # Optional: use existing PVC
```

The chart creates persistent volumes for:
- `/var/app/storage` - Main application storage (configurable, persistent by default)
- `/var/app/public` - Public assets (ephemeral, emptyDir)
- `/var/app/tmp/imports/watched` - Import watched directory (ephemeral, emptyDir)

**Note:** Only the main storage directory is persistent by default. If you need persistence for public assets or watched imports, you'll need to configure additional PVCs.

### Prometheus Metrics

Prometheus metrics exporter can be enabled for monitoring:

```yaml
config:
  prometheus:
    enabled: false             # Enable Prometheus exporter
    host: "0.0.0.0"           # Exporter host
    port: 9394                # Exporter port
```

When enabled, metrics will be exposed on port 9394 for both the main application and sidekiq worker.

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
