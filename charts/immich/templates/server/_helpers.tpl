{{/*
API (server) component labels - selector labels (immutable, no version)
*/}}
{{- define "immich.api.selectorLabels" -}}
{{- include "component.selectorLabels" (dict "componentName" "api" "ctx" .) -}}
{{- end -}}

{{/*
API (server) component labels - pod labels (with version)
*/}}
{{- define "immich.api.podLabels" -}}
{{- include "component.podLabels" (dict "componentName" "api" "imageTag" .Values.server.image.tag "ctx" .) -}}
{{- end -}}