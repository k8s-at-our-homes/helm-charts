# Immich

## How to use

Add repository by running:

```bash
helm repo add k8s-at-our-home https://k8s-at-our-homes.github.io/helm-charts/
helm install immich k8s-at-our-home/immich
```

Or get the chart from ghcr.io:

```bash
helm install immich oci://ghcr.io/k8s-at-our-homes/helm-charts
```

## Database Backups

The chart can schedule an additional Barman Cloud base backup to a separate
object store. Enable the primary backup configuration as well as the secondary target:

```yaml
database:
	backups:
		enabled: true
		destination: s3://primary-backups/immich
		secretName: primary-backup-credentials
		secondary:
			enabled: true
			destination: s3://secondary-backups/immich
			secretName: secondary-backup-credentials
			schedule: '0 0 1 * * *'
```

The secondary target stores full base backups only. WAL archiving continues to
use the primary target, so recovery from the secondary target still requires
access to the appropriate WAL archive. The Barman Cloud CNPG-I plugin and its
CRDs must be installed separately, and the referenced credentials must already
exist.
