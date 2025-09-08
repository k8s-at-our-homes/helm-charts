{{/*
Resolver component labels - selector labels (immutable, no version)
*/}}
{{- define "adguard.resolver.selectorLabels" -}}
{{- include "component.selectorLabels" (dict "componentName" "resolver" "ctx" .) -}}
{{- end -}}

{{/*
Resolver component labels - pod labels (with version)
*/}}
{{- define "adguard.resolver.podLabels" -}}
{{- include "component.podLabels" (dict "componentName" "resolver" "imageTag" .Values.global.image.tag "ctx" .) -}}
{{- end -}}