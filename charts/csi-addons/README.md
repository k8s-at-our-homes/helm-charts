# CSI Addons

## How to use

Add repository by running:

```bash
helm repo add k8s-at-our-home https://k8s-at-our-homes.github.io/helm-charts/
helm install csi-addons k8s-at-our-home/csi-addons
```

Or get the chart from ghcr.io:

```bash
helm install csi-addons oci://ghcr.io/k8s-at-our-homes/helm-charts/csi-addons
```
