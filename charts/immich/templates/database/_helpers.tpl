{{/*
Database component labels - selector labels (immutable, no version)
*/}}
{{- define "immich.database.selectorLabels" -}}
app.kubernetes.io/name: postgresql
app.kubernetes.io/component: database
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: immich
{{- end -}}

{{/*
Database component labels - pod labels (with version)
*/}}
{{- define "immich.database.podLabels" -}}
app.kubernetes.io/name: postgresql
app.kubernetes.io/component: database
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.database.image.tag | quote }}
app.kubernetes.io/part-of: immich
{{- end -}}