FROM ghcr.io/gchq/cyberchef:10.19.0 AS build
FROM nginxinc/nginx-unprivileged:1.27.0-alpine3.19 AS run

LABEL org.opencontainers.image.source = "https://github.com/k8s-at-our-homes/helm-charts"

COPY --from=build /usr/share/nginx/html /usr/share/nginx/html

