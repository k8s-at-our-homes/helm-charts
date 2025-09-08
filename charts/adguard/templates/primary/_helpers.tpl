{{/*
Frontend component labels - selector labels (immutable, no version)
*/}}
{{- define "adguard.frontend.selectorLabels" -}}
{{- include "component.selectorLabels" (dict "componentName" "frontend" "ctx" .) -}}
{{- end -}}

{{/*
Frontend component labels - pod labels (with version)
*/}}
{{- define "adguard.frontend.podLabels" -}}
{{- include "component.podLabels" (dict "componentName" "frontend" "imageTag" .Values.global.image.tag "ctx" .) -}}
{{- end -}}