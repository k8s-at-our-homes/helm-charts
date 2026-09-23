{{- define "dawarich.secretInit.selectorLabels" -}}
app.kubernetes.io/name: dawarich
app.kubernetes.io/component: secret-init
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: dawarich
{{- end -}}

{{- define "dawarich.secretInit.podLabels" -}}
{{ include "dawarich.secretInit.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.secretInit.image.tag | quote }}
{{- end -}}

{{- define "dawarich.secretInit.objectLabels" -}}
{{ include "dawarich.secretInit.podLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "dawarich.chartName" . }}
{{- end -}}
