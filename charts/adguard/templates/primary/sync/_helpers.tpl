{{- define "adguard.sync.selectorLabels" -}}
app.kubernetes.io/component: sync
{{ include "adguard.chartLabels" . }}
{{- end -}}

{{- define "adguard.sync.podLabels" -}}
{{ include "adguard.sync.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.primary.sync.image.tag | quote }}
{{- end -}}

{{- define "adguard.sync.objectLabels" -}}
{{ include "adguard.sync.podLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "adguard.chartName" . }}
{{- end -}}