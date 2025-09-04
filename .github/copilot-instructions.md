# Kubernetes Helm Charts Repository

This repository provides Helm charts for common Kubernetes applications used in home lab and self-hosted environments. The charts are published to both GitHub Pages and GitHub Container Registry (GHCR).

**ALWAYS follow these instructions first and fallback to search or additional context only when the information here is incomplete or found to be in error.**

## Working Effectively

### Prerequisites and Tool Installation
- Ensure `helm` is installed (v3.12.0+ recommended): Already available at `/usr/local/bin/helm`
- Ensure `docker` is installed for image building: Already available at `/usr/bin/docker`
- Ensure `yq` is installed for YAML processing: Already available at `/usr/bin/yq`
- Ensure `kubectl` is installed for Kubernetes operations: Already available at `/usr/bin/kubectl`

### Initial Repository Setup
**Run this once when starting work on the repository:**
```bash
# Add required Helm repositories for charts with dependencies
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### Core Development Commands
**NEVER CANCEL these operations - they complete in under 10 seconds:**

```bash
# Build chart dependencies (< 5 seconds)
helm dependency build charts/<chart-name>

# Generate and validate chart templates (< 5 seconds) 
helm template "<chart-name>" charts/<chart-name>

# Lint chart for errors and best practices (< 5 seconds)
helm lint charts/<chart-name>

# Package chart for distribution (< 5 seconds)
helm package charts/<chart-name>
```

### Build and Test All Charts
Run this complete validation suite (takes 60-90 seconds total):
```bash
for chart in charts/*/; do 
  chartname=$(basename "$chart")
  echo "Testing $chartname..."
  helm dependency build "$chart" && \
  helm template "$chartname" "$chart" > /dev/null && \
  helm lint "$chart" && \
  echo "✓ $chartname passed" || \
  echo "✗ $chartname failed (expected for gatus due to external dependency)"
done
```

**Expected Results:**
- 7 charts should pass: adguard, cyberchef, dawarich, generic-device-plugin, home-assistant, immich, plugin-barman-cloud
- 1 chart will fail: gatus (due to unreachable external dependency - this is normal)

### Docker Image Building
**Time expectation: 5-10 seconds per image, NEVER CANCEL:**
```bash
# Build Docker images (currently only cyberchef available)
docker build images/cyberchef/ -t test-cyberchef

# Subsequent builds are much faster due to Docker layer caching (< 1 second)
```

**Docker Build Notes:**
- First build: 5-10 seconds (downloads base images)
- Cached builds: < 1 second (uses layer cache)
- Images may show warnings about LABEL format - these are cosmetic

## Validation Requirements

### Chart Validation Checklist
**ALWAYS run these validations after making changes to any chart:**
1. `helm dependency build charts/<chart-name>` - Must succeed
2. `helm template "<chart-name>" charts/<chart-name>` - Must generate valid YAML
3. `helm lint charts/<chart-name>` - Must pass (warnings about missing icons are acceptable)
4. `helm package charts/<chart-name>` - Must create .tgz file successfully

### Version Management Validation
After modifying a chart, verify version handling:
```bash
# Extract and verify chart version
yq eval ".version" charts/<chart-name>/Chart.yaml

# Ensure version follows semantic versioning (e.g., "1.2.3")
```

### Repository Integration Validation
Before committing, ensure CI compatibility:
```bash
# Test commands used in GitHub Actions
helm dependency build charts/<chart-name>
helm template "<chart-name>" charts/<chart-name>
helm lint charts/<chart-name>
```

## Repository Structure

### Chart Organization
```
charts/
├── adguard/           # DNS filtering and ad-blocking
├── cyberchef/         # Data analysis and manipulation tool
├── dawarich/          # Location tracking (has Redis dependency)
├── gatus/             # Uptime monitoring (external dependency may fail)
├── generic-device-plugin/  # Kubernetes device plugin
├── home-assistant/    # Home automation platform
├── immich/            # Photo management (has Redis dependency)
└── plugin-barman-cloud/    # PostgreSQL backup plugin
```

### Chart Structure (Standard)
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
```
images/
└── cyberchef/         # Custom Docker image for CyberChef
    └── Dockerfile     # Multi-stage build configuration
```

## Common Issues and Solutions

### Dependency Failures
**Known Issue:** The `gatus` chart depends on `https://twin.github.io/helm-charts` which may be unreachable.
```bash
# If dependency build fails for gatus:
# Error: no cached repository found
# This is a known external dependency issue - document but continue with other charts
```

### External Dependencies That Work
- `https://charts.bitnami.com/bitnami` (Redis) - Used by dawarich and immich charts
- Downloads typically complete in 5-10 seconds

### Network Connectivity
- External helm repositories may occasionally timeout
- Most charts have no external dependencies and work offline
- Bitnami repository is reliable and fast

## GitHub Actions Integration

### Workflow Files
- `.github/workflows/chart-build.yaml` - Validates charts on PRs
- `.github/workflows/image-build.yaml` - Builds Docker images
- `.github/workflows/release.yaml` - Publishes releases

### CI Commands (Used in Actions)
The CI uses these exact commands that you should also use:
```bash
# Chart validation (matches CI exactly)
helm dependency build charts/$CHART
helm template "$CHART" charts/$CHART
helm lint charts/$CHART

# Version extraction (matches CI exactly) 
yq eval ".version" charts/$CHART/Chart.yaml

# Package building (matches CI exactly)
helm package charts/$CHART
```

## Chart Development Best Practices

### Creating New Charts
1. Copy structure from existing chart (e.g., `cyberchef` for simple apps)
2. Update `Chart.yaml` with new name, version, and description
3. Modify `values.yaml` for application-specific configuration
4. Update templates in `templates/` directory
5. Create `README.md` with installation instructions

### Modifying Existing Charts
1. **ALWAYS** increment version in `Chart.yaml` when making changes
2. Test with the validation commands above
3. Update `README.md` if values or usage changes
4. Follow existing patterns in similar charts

### Required Files for Every Chart
- `Chart.yaml` - Must have name, version, apiVersion v2
- `values.yaml` - Default configuration
- `templates/` directory with at least deployment and service
- `README.md` - Installation and usage instructions

## Time Expectations

**All operations are fast - NEVER CANCEL:**
- `helm dependency build`: < 5 seconds (or 10-15 seconds with external deps like Redis)
- `helm template`: < 5 seconds  
- `helm lint`: < 5 seconds
- `helm package`: < 5 seconds
- `docker build`: 5-10 seconds per image
- Full chart test suite: 60-90 seconds for all 8 charts (with 1 expected failure)
- `helm repo add` and `helm repo update`: 5-10 seconds total

## Testing Scenarios

### Chart Functionality Testing
**Cannot perform runtime testing** - No Kubernetes cluster available in this environment.
Focus on template generation and lint validation:
```bash
# Verify chart generates valid Kubernetes manifests (validation only)
helm template test-release charts/<chart-name> > /tmp/test-output.yaml
# Note: kubectl dry-run requires cluster access, so use helm template + lint instead
```

### Docker Image Testing  
```bash
# Build and verify image creation
docker build images/<image-name>/ -t test-<image-name>
docker images | grep test-<image-name>
```

## Quick Reference Commands

### Most Frequently Used Commands
```bash
# Test single chart completely
helm dependency build charts/adguard && helm template adguard charts/adguard && helm lint charts/adguard

# Check chart version
yq eval ".version" charts/adguard/Chart.yaml

# List all charts
ls charts/

# Clean up test artifacts  
rm -f *.tgz /tmp/test-output.yaml
docker rmi test-* 2>/dev/null || echo "No test images to clean"

# Check for chart changes (useful for CI simulation)
git diff --name-only | grep ^charts/ | cut -d/ -f2 | uniq
```

### Repository Maintenance
```bash
# Update dependencies for charts that have them
helm dependency update charts/dawarich
helm dependency update charts/immich
helm dependency update charts/gatus  # May fail due to external dependency
```

## Chart-Specific Notes

### Charts with External Dependencies
- **dawarich**: Depends on Bitnami Redis - works reliably
- **immich**: Depends on Bitnami Redis - works reliably  
- **gatus**: Depends on twin.github.io/helm-charts - may fail, this is expected

### Charts without Dependencies
- **adguard**: Self-contained, always works
- **cyberchef**: Self-contained, always works
- **generic-device-plugin**: Self-contained, always works
- **home-assistant**: Self-contained, always works
- **plugin-barman-cloud**: Self-contained, works reliably

### Docker Images
- **cyberchef**: Multi-stage build, creates nginx-based image from upstream CyberChef