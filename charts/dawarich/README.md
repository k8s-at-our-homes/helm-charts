
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

### Application Security

The Dawarich application and Sidekiq containers run as non-root UID/GID 1000
with a read-only root filesystem. Writable application paths are backed by
ephemeral storage, including the Rails database schema directory, while
Photon geodata remains on its persistent volume.

Both containers run Rails in production mode. The chart generates a
`SECRET_KEY_BASE` in a Kubernetes Secret on first install and reuses it on
upgrades. Back up this Secret: changing or losing the key signs everyone out
and can make encrypted archives unreadable. The chart manages an initially
empty `<chart-fullname>-secret`; a post-install/post-upgrade Helm hook patches
in `secret-key-base` only if the key is missing. Helm and GitOps tools can
track and remove the Secret on uninstall without storing the key in chart
values. Back up the Secret **before** uninstalling; reinstalling generates a
new key. The hook's ServiceAccount and RBAC are also chart-managed, and the
Job is removed when it finishes.

When upgrading an installation using the earlier unmanaged Secret hook,
first give the existing Secret to Helm rather than deleting it (which would
lose the key). Adopt any existing hook ServiceAccount, Role and RoleBinding
too, so they can be cleaned up on uninstall. For a Helm release named
`dawarich` in namespace `default`, run:

```bash
kubectl -n default label secret/dawarich-secret serviceaccount/dawarich-init-secret-job role/dawarich-init-secret-job rolebinding/dawarich-init-secret-job app.kubernetes.io/managed-by=Helm --overwrite
kubectl -n default annotate secret/dawarich-secret serviceaccount/dawarich-init-secret-job role/dawarich-init-secret-job rolebinding/dawarich-init-secret-job meta.helm.sh/release-name=dawarich meta.helm.sh/release-namespace=default --overwrite
```

If the previous release used `existingSecret`, those hook RBAC resources
will not exist; adopt only the Secret if it has the chart's expected name.
Replace the release name and namespace in both the resource names and
annotations if yours differ. The secret hook runs after normal chart
resources are created. On a new install, `helm install --wait` can block
the post-install hook while waiting for the app to become ready without
its key; install without `--wait` and then verify that the Job completes
and both containers become ready. Argo CD translates Helm post-install
hooks into PostSync hooks; its default health gate can likewise block this
bootstrap on a new installation. This Helm-hook-based bootstrap therefore
requires a separately configured sync/health strategy for an Argo CD
first install.

The `hostname` value also sets `DOMAIN`, which production email links need.
Set it to the public hostname of your instance (without a scheme or path).
When switching an existing deployment from development mode, review the
[upstream migration guidance](https://dawarich.app/docs/self-hosting/environment-variables/#switching-an-existing-instance-to-production):
encrypted geocoding settings may need to be entered again, and existing
archives may require preserving the previous encryption key.

**Storage warning:** `/var/app/storage` uses `emptyDir`, not a persistent
volume. Upstream Dawarich uses this directory for Active Storage files,
including uploaded imports, posters, saved videos, and (if enabled) raw-data
archives. These files are lost when the Pod is replaced even though their
database records remain. Back up or migrate this data before upgrading or
replacing Pods; this chart does not currently provide a persistent storage
option for it. Watched-directory imports likewise are not exposed through
a shared, persistent volume in this chart.

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
- **Security:** Photon runs as a non-root user with a read-only root filesystem. Runtime files use ephemeral storage, while geodata persists in `/photon/data`.

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
