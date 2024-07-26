# Home Assistant

## How to use

Add repository by running:

```bash
helm repo add k8s-at-our-home https://k8s-at-our-homes.github.io/helm-charts/
helm install home-assistant k8s-at-our-home/home-assistant
```

Or get the chart from ghcr.io:

```bash
helm install home-assistant oci://ghcr.io/k8s-at-our-homes/helm-charts/home-assistant
```
