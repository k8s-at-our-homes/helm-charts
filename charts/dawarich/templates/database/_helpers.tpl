{{/*
Database (PostgreSQL) component labels - selector labels (immutable, no version)
*/}}
{{- define "dawarich.database.selectorLabels" -}}
app.kubernetes.io/name: postgresql
app.kubernetes.io/component: database
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: dawarich
{{- end -}}

{{/*
Database (PostgreSQL) component labels - pod labels (with version)
*/}}
{{- define "dawarich.database.podLabels" -}}
app.kubernetes.io/name: postgresql
app.kubernetes.io/component: database
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.database.image.tag | quote }}
app.kubernetes.io/part-of: dawarich
{{- end -}}