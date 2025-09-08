{{/*
Photon search engine component labels - selector labels (immutable, no version)
*/}}
{{- define "dawarich.photon.selectorLabels" -}}
{{- include "component.selectorLabels" (dict "componentName" "photon" "ctx" .) -}}
{{- end -}}

{{/*
Photon search engine component labels - pod labels (with version)
*/}}
{{- define "dawarich.photon.podLabels" -}}
{{- include "component.podLabels" (dict "componentName" "photon" "imageTag" .Values.photon.image.tag "ctx" .) -}}
{{- end -}}