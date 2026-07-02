{{/*
API (server) component labels - selector labels (immutable, no version)
*/}}
{{- define "immich.api.selectorLabels" -}}
app.kubernetes.io/name: immich
app.kubernetes.io/component: api
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: immich
{{- end -}}

{{/*
API (server) component labels - pod labels (with version)
*/}}
{{- define "immich.api.podLabels" -}}
{{ include "immich.api.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.server.image.tag | quote }}
{{- end -}}

{{- define "immich.api.objectLabels" -}}
{{ include "immich.api.podLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "immich.chartName" . }}
{{- end -}}