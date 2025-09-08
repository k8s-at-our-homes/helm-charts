{{/*
API (server) component labels - selector labels (immutable, no version)
*/}}
{{- define "immich.api.selectorLabels" -}}
app.kubernetes.io/name: api
app.kubernetes.io/component: api
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: immich
{{- end -}}

{{/*
API (server) component labels - pod labels (with version)
*/}}
{{- define "immich.api.podLabels" -}}
app.kubernetes.io/name: api
app.kubernetes.io/component: api
helm.sh/chart: {{ include "chartName" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.server.image.tag | quote }}
app.kubernetes.io/part-of: immich
{{- end -}}