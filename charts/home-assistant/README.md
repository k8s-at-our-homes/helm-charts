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

## Configuration

To pass config to home assistant we use the kiwigrid sidecar config loader.
The loader will load any secret or configmap with the label `home-assistant-config: "1"` into the folder `/config` where home assistant will load the config file.

If your file should be loaded to an alternative directory you can specify the container directory with the annotation `io.home-assistant/config-folder`.

