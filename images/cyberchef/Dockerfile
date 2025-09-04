# Stage 1: Extract upstream CyberChef release
FROM ghcr.io/gchq/cyberchef:10.19.4 AS upstream

# Stage 2: Apply patches to override default options
FROM alpine:3.19 AS patcher

# Note: sed is already available in Alpine base, bash is not needed for this script

# Copy files from upstream
COPY --from=upstream /usr/share/nginx/html /tmp/html

# Copy patch script
COPY patch-config.sh /tmp/patch-config.sh

# Apply patch to disable updateUrl for self-hosted environments
RUN chmod +x /tmp/patch-config.sh && \
    /tmp/patch-config.sh /tmp/html && \
    rm /tmp/patch-config.sh

# Stage 3: Final image with patched content
FROM nginxinc/nginx-unprivileged:1.27.0-alpine3.19 AS run

LABEL org.opencontainers.image.source="https://github.com/k8s-at-our-homes/helm-charts"
LABEL org.opencontainers.image.authors="k8s-at-our-homes"
LABEL org.opencontainers.image.description="CyberChef with patched defaults for self-hosted environments"

# Copy patched content from patcher stage
COPY --from=patcher /tmp/html /usr/share/nginx/html

