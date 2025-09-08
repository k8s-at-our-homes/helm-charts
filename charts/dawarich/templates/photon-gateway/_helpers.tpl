{{/*
Photon Gateway (load balancer) component labels - selector labels (immutable, no version)
*/}}
{{- define "dawarich.photonGateway.selectorLabels" -}}
{{- include "component.selectorLabels" (dict "componentName" "photon-gateway" "ctx" .) -}}
{{- end -}}

{{/*
Photon Gateway (load balancer) component labels - pod labels (with version)
*/}}
{{- define "dawarich.photonGateway.podLabels" -}}
{{- include "component.podLabels" (dict "componentName" "photon-gateway" "imageTag" .Values.photon.gateway.image.tag "ctx" .) -}}
{{- end -}}