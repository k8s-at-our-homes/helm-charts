# CyberChef Container Image

This directory contains a custom CyberChef container image that applies patches to upstream CyberChef for better self-hosted environments.

## Changes from Upstream

- **updateUrl disabled**: The `updateUrl` option is set to `false` to prevent the application from attempting to check for updates from external sources, which is more appropriate for self-hosted environments.

## Build Process

The Dockerfile uses a multi-stage build:

1. **Stage 1 (upstream)**: Extract content from the official CyberChef image
2. **Stage 2 (patcher)**: Apply patches to override default options 
3. **Stage 3 (run)**: Package the patched content into an nginx-unprivileged container

## Patch Details

The patch script (`patch-config.sh`) modifies the minified `main.js` file to change:
- `updateUrl:!0` → `updateUrl:!1` (true → false in minified JavaScript)

This ensures that CyberChef will not attempt to connect to external update servers when running in a self-hosted environment.

## Multi-Platform Support

The image supports both amd64 and arm64 architectures and produces consistent patched builds across platforms.