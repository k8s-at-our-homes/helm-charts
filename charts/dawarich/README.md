# Dawarich

## How to use

Add repository by running:

```bash
helm repo add k8s-at-our-home https://k8s-at-our-homes.github.io/helm-charts/
helm install dawarich k8s-at-our-home/dawarich
```

Or get the chart from ghcr.io:

```bash
helm install dawarich oci://ghcr.io/k8s-at-our-homes/helm-charts
```

## Photon Reverse Geocoding

This chart includes support for Photon reverse geocoding with three configuration options:

### 1. External Photon API (default)
When `photon.deploy=false` (default), Dawarich uses the public Photon API at `photon.komoot.io`.

### 2. Self-hosted Photon Instance
When `photon.deploy=true`, the chart deploys a local Photon instance with configurable country data.

### 3. Smart Reverse Proxy (recommended for limited datasets)
When `envoyProxy.enabled=true`, an Envoy reverse proxy provides intelligent load balancing:

1. **Primary**: Uses internal Photon instance first (if deployed)
2. **Fallback**: If no results, tries public instances in round-robin:
   - https://photon.koalasec.org
   - https://photon.donsomhong.net (rate limited)
   - https://photon.marsmathis.com
   - https://photon.vanoosterhout.cloud (rate limited)
   - https://photon.kllswitch.com

This approach provides privacy for areas covered by your local dataset while ensuring global coverage through public instances.

```yaml
# Example configuration for smart reverse proxy
envoyProxy:
  enabled: true
photon:
  deploy: true
  config:
    country: "NL"  # Limit local data to Netherlands
```
