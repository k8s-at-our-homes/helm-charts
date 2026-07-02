{{/*
Frontend component labels - selector labels (immutable, no version)
*/}}
{{- define "adguard.frontend.selectorLabels" -}}
app.kubernetes.io/component: frontend
{{ include "adguard.chartLabels" . }}
{{- end -}}

{{/*
Frontend component labels - pod labels (with version)
*/}}
{{- define "adguard.frontend.podLabels" -}}
{{ include "adguard.frontend.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.adguard.image.tag | quote }}
{{- end -}}

{{- define "adguard.frontend.objectLabels" -}}
{{ include "adguard.frontend.podLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "adguard.chartName" . }}
{{- end -}}