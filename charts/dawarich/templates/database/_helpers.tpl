{{/*
Database (PostgreSQL) component labels - selector labels (immutable, no version)
*/}}
{{- define "dawarich.database.selectorLabels" -}}
{{- include "component.selectorLabels" (dict "componentName" "database" "ctx" .) -}}
{{- end -}}

{{/*
Database (PostgreSQL) component labels - pod labels (with version)
*/}}
{{- define "dawarich.database.podLabels" -}}
{{- include "component.podLabels" (dict "componentName" "database" "imageTag" .Values.database.image.tag "ctx" .) -}}
{{- end -}}