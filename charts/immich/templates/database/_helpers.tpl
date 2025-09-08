{{/*
Database component labels - selector labels (immutable, no version)
*/}}
{{- define "immich.database.selectorLabels" -}}
{{- include "component.selectorLabels" (dict "componentName" "database" "ctx" .) -}}
{{- end -}}

{{/*
Database component labels - pod labels (with version)
*/}}
{{- define "immich.database.podLabels" -}}
{{- include "component.podLabels" (dict "componentName" "database" "imageTag" .Values.database.image.tag "ctx" .) -}}
{{- end -}}