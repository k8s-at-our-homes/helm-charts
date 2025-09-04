# Kubernetes Helm Charts Repository

This repository provides Helm charts for Kubernetes applications. Charts are organized in the `/charts` directory and Docker images in the `/images` directory.

**ALWAYS follow these instructions first and fallback to search or additional context only when the information here is incomplete or found to be in error.**

## Pull Request Titles
All PR titles must start with [product-name], e.g. [home-assistant] Add MQTT support.

## Commit Messages
- Use imperative mood ("Add X", not "Added X").
- Prefix with [product-name] when relevant.

## Core Development Commands

### Chart Validation
**Only validate charts that have been modified in your changes:**

```bash
# Build chart dependencies
helm dependency build charts/<chart-name>

# Generate and validate chart templates
helm template "<chart-name>" charts/<chart-name>

# Lint chart for errors and best practices
helm lint charts/<chart-name>

# Package chart for distribution
helm package charts/<chart-name>
```

#### Kubeconform Validation
Use Kubeconform to validate generated manifests against Kubernetes schemas:

```bash
# Validate manifests using Kubeconform (Docker) with CRD support
# Note: Use insecure-skip-tls-verify due to TLS certificate verification issues in sandboxed environments
helm template "<chart-name>" charts/<chart-name> | \
  docker run --rm -i ghcr.io/yannh/kubeconform:latest \
  -summary -verbose -insecure-skip-tls-verify \
  -schema-location default \
  -schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json'

# Alternative: Install Kubeconform locally and run validation
# Installation: brew install kubeconform (macOS) or go install github.com/yannh/kubeconform/cmd/kubeconform@latest
helm template "<chart-name>" charts/<chart-name> | \
  kubeconform -summary -verbose \
  -schema-location default \
  -schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json'
```

### Docker Image Building
**Only build Docker images that have been modified in your changes:**

```bash
# Build Docker images
docker build images/<image-name>/ -t test-<image-name>
```

### Version Management
When modifying a chart, always increment the version in `Chart.yaml`:
```bash
# Check current version
yq eval ".version" charts/<chart-name>/Chart.yaml
```

## Repository Structure

### Chart Organization
Charts are organized in the `/charts` directory with each chart in its own subdirectory.

### Standard Chart Structure
```
charts/<chart-name>/
├── Chart.yaml         # Chart metadata and version
├── README.md          # Usage instructions
├── values.yaml        # Default configuration values
├── templates/         # Kubernetes manifests
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   └── _helpers.tpl   # Template helpers
└── .helmignore        # Files to exclude from packaging
```

### Images Directory
Docker images are organized in the `/images` directory with each image in its own subdirectory containing a Dockerfile.

## External Dependencies

External helm repositories or other resources may be blocked by the Copilot firewall. If an external dependency is blocked:

1. **Do not try to work around the block**
2. **Either skip that specific task and continue with other tasks if possible**
3. **Or stop work and ask for the external resource to be allowed in the firewall before continuing**

## Chart Development Best Practices

### Creating New Charts
1. Copy structure from existing chart for consistency
2. Update `Chart.yaml` with new name, version, and description
3. Modify `values.yaml` for application-specific configuration
4. Update templates in `templates/` directory
5. Create `README.md` with installation instructions

### Modifying Existing Charts
1. **ALWAYS** increment version in `Chart.yaml` when making changes
2. Validate with the chart validation commands
3. Update `README.md` if values or usage changes
4. Follow existing patterns in similar charts

### Required Files for Every Chart
- `Chart.yaml` - Must have name, version, apiVersion v2
- `values.yaml` - Default configuration
- `templates/` directory with at least deployment and service
- `README.md` - Installation and usage instructions

## Chart Updates

Charts are updated through automated Renovate PRs. **Do not update chart dependencies outside of Renovate PRs.**
