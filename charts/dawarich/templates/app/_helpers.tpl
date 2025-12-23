{{/*
Backend (main dawarich app) component labels - selector labels (immutable, no version)
*/}}
{{- define "dawarich.backend.selectorLabels" -}}
app.kubernetes.io/name: dawarich
app.kubernetes.io/component: backend
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: dawarich
{{- end -}}

{{/*
Backend (main dawarich app) component labels - pod labels (with version)
*/}}
{{- define "dawarich.backend.podLabels" -}}
app.kubernetes.io/name: dawarich
app.kubernetes.io/component: backend
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.app.image.tag | quote }}
app.kubernetes.io/part-of: dawarich
{{- end -}}