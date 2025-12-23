{{/*
Photon Gateway (load balancer) component labels - selector labels (immutable, no version)
*/}}
{{- define "dawarich.photonGateway.selectorLabels" -}}
app.kubernetes.io/name: envoy
app.kubernetes.io/component: photon-gateway
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: dawarich
{{- end -}}

{{/*
Photon Gateway (load balancer) component labels - pod labels (with version)
*/}}
{{- define "dawarich.photonGateway.podLabels" -}}
app.kubernetes.io/name: envoy
app.kubernetes.io/component: photon-gateway
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.photon.gateway.image.tag | quote }}
app.kubernetes.io/part-of: dawarich
{{- end -}}