{{- define "adguard.initSecretJob.selectorLabels" -}}
app.kubernetes.io/component: init-secret-job
{{ include "adguard.chartLabels" . }}
{{- end -}}

{{- define "adguard.initSecretJob.podLabels" -}}
{{ include "adguard.initSecretJob.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.secretInit.image.tag | quote }}
{{- end -}}

{{- define "adguard.initSecretJob.objectLabels" -}}
{{ include "adguard.initSecretJob.podLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "adguard.chartName" . }}
{{- end -}}