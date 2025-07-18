# plugin-barman-cloud

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.4.0](https://img.shields.io/badge/AppVersion-0.4.0-informational?style=flat-square)

CloudNativePG plugin for barman cloud Helm Chart

**Homepage:** <https://cloudnative-pg.io>

## Source Code

* <https://github.com/cloudnative-pg/plugin-barman-cloud>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalArgs | list | `[]` | Additional arguments to be added to the operator's args list. |
| additionalEnv | list | `[]` | Array containing extra environment variables which can be templated. For example:  - name: RELEASE_NAME    value: "{{ .Release.Name }}"  - name: MY_VAR    value: "mySpecialKey" |
| affinity | object | `{}` | Affinity for the operator to be installed. |
| certificate.createClientCertificate | bool | `true` | Specifies whether the client certificate should be created. |
| certificate.createServerCertificate | bool | `true` | Specifies whether the server certificate should be created. |
| certificate.duration | string | `"2160h"` | The duration of the certificates. |
| certificate.issuerName | string | `"selfsigned-issuer"` | The name of the issuer to use for the certificates. |
| certificate.renewBefore | string | `"360h"` | The renew before time for the certificates. |
| commonAnnotations | object | `{}` | Annotations to be added to all other resources. |
| containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":10001,"runAsUser":10001,"seccompProfile":{"type":"RuntimeDefault"}}` | Container Security Context. |
| crds.create | bool | `true` | Specifies whether the CRDs should be created when installing the chart. |
| dnsPolicy | string | `""` |  |
| fullnameOverride | string | `""` |  |
| hostNetwork | bool | `false` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.registry | string | `"ghcr.io"` |  |
| image.repository | string | `"cloudnative-pg/plugin-barman-cloud"` |  |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| namespaceOverride | string | `""` |  |
| nodeSelector | object | `{}` | Nodeselector for the operator to be installed. |
| podAnnotations | object | `{}` | Annotations to be added to the pod. |
| podLabels | object | `{}` | Labels to be added to the pod. |
| podSecurityContext | object | `{"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Security Context for the whole pod. |
| priorityClassName | string | `""` | Priority indicates the importance of a Pod relative to other Pods. |
| rbac.additional.leaderElection.create | bool | `true` | Specifies whether the leader election Role and RoleBinding should be created. |
| rbac.additional.metricsAuth.create | bool | `true` | Specifies whether the metrics auth ClusterRole and ClusterRoleBinding should be created. |
| rbac.additional.metricsReader.create | bool | `true` | Specifies whether the metrics reader ClusterRole should be created. |
| rbac.additional.objectStore.editor.create | bool | `true` | Specifies whether the object store editor ClusterRole should be created. |
| rbac.additional.objectStore.viewer.create | bool | `true` | Specifies whether the object store viewer ClusterRole should be created. |
| rbac.create | bool | `true` | Specifies whether ClusterRole and ClusterRoleBinding should be created. |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| service.ipFamilies | list | `[]` | Sets the families that should be supported and the order in which they should be applied to ClusterIP as well. Can be IPv4 and/or IPv6. |
| service.ipFamilyPolicy | string | `""` | Set the ip family policy to configure dual-stack see [Configure dual-stack](https://kubernetes.io/docs/concepts/services-networking/dual-stack/#services) |
| service.name | string | `"cnpg-webhook-service"` | DO NOT CHANGE THE SERVICE NAME as it is currently used to generate the certificate and can not be configured |
| service.port | int | `9090` |  |
| serviceAccount.create | bool | `true` | Specifies whether the service account should be created. |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| tolerations | list | `[]` | Tolerations for the operator to be installed. |
| topologySpreadConstraints | list | `[]` | Topology Spread Constraints for the operator to be installed. |
| updateStrategy | object | `{}` | Update strategy for the operator. ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy For example:  type: RollingUpdate  rollingUpdate:    maxSurge: 25%    maxUnavailable: 25% |

