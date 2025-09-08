{{/*
Worker (machine-learning) component labels - selector labels (immutable, no version)
*/}}
{{- define "immich.worker.selectorLabels" -}}
{{- include "component.selectorLabels" (dict "componentName" "worker" "ctx" .) -}}
{{- end -}}

{{/*
Worker (machine-learning) component labels - pod labels (with version)
*/}}
{{- define "immich.worker.podLabels" -}}
{{- include "component.podLabels" (dict "componentName" "worker" "imageTag" .Values.machineLearning.image.tag "ctx" .) -}}
{{- end -}}