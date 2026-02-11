FROM ghcr.io/gchq/cyberchef:10.22.0 AS upstream

# Apply patches to override default options
FROM alpine:3.23 AS patcher

# Copy files from upstream
COPY --from=upstream /usr/share/nginx/html /tmp/html

# Copy patch script
COPY patch-config.sh /tmp/patch-config.sh

# Apply patch to disable updateUrl for privacy
RUN chmod +x /tmp/patch-config.sh && \
    /tmp/patch-config.sh /tmp/html && \
    rm /tmp/patch-config.sh

# Final image with patched content
FROM nginxinc/nginx-unprivileged:1.27.0-alpine3.19 AS run

LABEL org.opencontainers.image.source="https://github.com/k8s-at-our-homes/helm-charts"
LABEL org.opencontainers.image.authors="k8s-at-our-homes"
LABEL org.opencontainers.image.description="CyberChef with patched defaults for better privacy"

# Copy patched content from patcher stage
COPY --from=patcher /tmp/html /usr/share/nginx/html

