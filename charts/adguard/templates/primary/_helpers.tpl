{{/*
Frontend component labels - selector labels (immutable, no version)
*/}}
{{- define "adguard.frontend.selectorLabels" -}}
app.kubernetes.io/name: frontend
app.kubernetes.io/component: frontend
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: adguard
{{- end -}}

{{/*
Frontend component labels - pod labels (with version)
*/}}
{{- define "adguard.frontend.podLabels" -}}
app.kubernetes.io/name: frontend
app.kubernetes.io/component: frontend
helm.sh/chart: {{ include "chartName" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.global.image.tag | quote }}
app.kubernetes.io/part-of: adguard
{{- end -}}