{{/*
Backend (main dawarich app) component labels - selector labels (immutable, no version)
*/}}
{{- define "dawarich.backend.selectorLabels" -}}
{{- include "component.selectorLabels" (dict "componentName" "backend" "ctx" .) -}}
{{- end -}}

{{/*
Backend (main dawarich app) component labels - pod labels (with version)
*/}}
{{- define "dawarich.backend.podLabels" -}}
{{- include "component.podLabels" (dict "componentName" "backend" "imageTag" .Values.app.image.tag "ctx" .) -}}
{{- end -}}