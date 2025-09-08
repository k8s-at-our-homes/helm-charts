{{/*
Worker (machine-learning) component labels - selector labels (immutable, no version)
*/}}
{{- define "immich.worker.selectorLabels" -}}
app.kubernetes.io/name: immich
app.kubernetes.io/component: worker
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: immich
{{- end -}}

{{/*
Worker (machine-learning) component labels - pod labels (with version)
*/}}
{{- define "immich.worker.podLabels" -}}
app.kubernetes.io/name: immich
app.kubernetes.io/component: worker
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.machineLearning.image.tag | quote }}
app.kubernetes.io/part-of: immich
{{- end -}}