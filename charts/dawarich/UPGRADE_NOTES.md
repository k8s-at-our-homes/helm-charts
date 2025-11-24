# Dawarich Helm Chart - Upgrade Notes

## Version 9.2.0 - Production Configuration Alignment

This release aligns the Dawarich Helm chart with the latest upstream docker-compose.yml configuration, introducing several important changes for production readiness.

### Breaking Changes

None. All new features are backward compatible with sensible defaults.

### New Features

#### 1. Production-Ready Rails Environment (Default Changed)

**Change:** `RAILS_ENV` is now configurable and defaults to `production` instead of `development`.

**Why:** Running Rails in development mode in production:
- Disables asset caching
- Enables verbose error pages with stack traces
- Reduces performance
- May expose sensitive information

**Configuration:**
```yaml
config:
  railsEnv: production  # Default, recommended for production
```

To maintain old behavior (not recommended):
```yaml
config:
  railsEnv: development
```

#### 2. Secret Key Base Management

**Change:** Added automatic SECRET_KEY_BASE generation and management.

**Why:** Rails requires a strong SECRET_KEY_BASE for:
- Session security
- Cookie encryption
- CSRF token generation

**Configuration:**
```yaml
config:
  secretKeyBase: ""  # Auto-generated if empty
```

For production, it's recommended to set a strong secret:
```bash
# Generate a secret
openssl rand -hex 64

# Set in values.yaml
config:
  secretKeyBase: "your-generated-secret-here"
```

#### 3. Persistent Storage (Default Changed)

**Change:** Application storage now uses PersistentVolumeClaim instead of emptyDir.

**Why:** emptyDir causes data loss on pod restarts, making it unsuitable for production.

**Configuration:**
```yaml
app:
  persistence:
    enabled: true        # Default
    size: 5Gi           # Default storage size
    storageClass: ""    # Optional: specify storage class
    existingClaim: ""   # Optional: use existing PVC
```

To maintain old behavior (not recommended):
```yaml
app:
  persistence:
    enabled: false
```

#### 4. Additional Volume Mounts

**Change:** Added volume mounts for all directories used by the upstream configuration:
- `/var/app/storage` - Persistent by default
- `/var/app/public` - Ephemeral (emptyDir)
- `/var/app/tmp/imports/watched` - Ephemeral (emptyDir)

**Why:** Aligns with upstream docker-compose.yml volume configuration.

#### 5. Container Logging

**Change:** Added `RAILS_LOG_TO_STDOUT` environment variable.

**Why:** Best practice for container logging - logs should go to stdout/stderr for Kubernetes to capture them.

**Configuration:**
```yaml
config:
  railsLogToStdout: true  # Default
```

#### 6. Prometheus Metrics Support

**Change:** Added Prometheus exporter configuration.

**Why:** Enables application monitoring and observability.

**Configuration:**
```yaml
config:
  prometheus:
    enabled: false      # Default, set to true to enable
    host: "0.0.0.0"    # Exporter bind address
    port: 9394         # Exporter port
```

When enabled, metrics are exposed at port 9394 on both the main application and sidekiq worker.

#### 7. Database Port Configuration

**Change:** Added `DATABASE_PORT` environment variable.

**Why:** Explicit configuration aligns with upstream and allows for non-standard ports if needed.

### Migration Guide

#### From Version 9.1.0 to 9.2.0

1. **No action required for most users** - The changes are backward compatible with sensible defaults.

2. **For production deployments**, review and set:
   ```yaml
   config:
     railsEnv: production  # Already default
     secretKeyBase: "your-strong-secret"  # Recommended to set explicitly
     prometheus:
       enabled: true  # Enable monitoring
   
   app:
     persistence:
       enabled: true  # Already default
       size: 5Gi     # Adjust based on your needs
   ```

3. **If you have existing data in emptyDir** and are upgrading with persistence enabled:
   - The chart will create a new PVC
   - You'll need to manually migrate data from the old pod to the new one
   - Or set `app.persistence.enabled: false` to maintain old behavior

4. **If you need to maintain development mode** (not recommended):
   ```yaml
   config:
     railsEnv: development
   ```

### Verification

After upgrading, verify the configuration:

```bash
# Check that RAILS_ENV is set to production
kubectl get deployment <release-name>-dawarich -o yaml | grep RAILS_ENV

# Check that SECRET_KEY_BASE secret exists
kubectl get secret <release-name>-dawarich-secret

# Check that PVC is created (if persistence is enabled)
kubectl get pvc <release-name>-dawarich-storage

# Check prometheus port (if enabled)
kubectl get service <release-name>-dawarich -o yaml | grep 9394
```

### Rollback

If you need to rollback to the previous version:

```bash
helm rollback <release-name>
```

Note: If persistence was enabled, you may need to manually handle the PVC.

## Comparison with Upstream Docker Compose

This release ensures feature parity with the upstream Dawarich docker-compose.yml configuration:

| Feature | Docker Compose | Helm Chart (9.2.0) | Status |
|---------|---------------|-------------------|---------|
| RAILS_ENV | configurable (default: development) | configurable (default: production) | ✅ Improved |
| SECRET_KEY_BASE | configurable | auto-generated or configurable | ✅ |
| RAILS_LOG_TO_STDOUT | true | true | ✅ |
| PROMETHEUS_EXPORTER_* | configurable | configurable | ✅ |
| DATABASE_PORT | 5432 | 5432 | ✅ |
| Persistent Storage | volumes | PersistentVolumeClaim | ✅ Improved |
| Health Checks | comprehensive | comprehensive | ✅ |
| All volume mounts | ✅ | ✅ | ✅ |

## Support

For issues or questions, please open an issue at: https://github.com/k8s-at-our-homes/helm-charts/issues
