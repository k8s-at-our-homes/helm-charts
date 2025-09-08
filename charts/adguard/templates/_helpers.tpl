{{- define "common.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "common.fullname" -}}
{{- if contains .Chart.Name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "chartName" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common selector labels - immutable, used for selectors (no version)
*/}}
{{- define "common.selectorLabels" -}}
app.kubernetes.io/name: adguard
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: adguard
{{- end -}}

{{/*
Common pod labels - includes version information
*/}}
{{- define "common.podLabels" -}}
app.kubernetes.io/name: adguard
helm.sh/chart: {{ include "chartName" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.global.image.tag | quote }}
app.kubernetes.io/part-of: adguard
{{- end -}}

{{/*
Legacy common labels - for compatibility with non-component resources
*/}}
{{- define "common.labels" -}}
{{- include "common.podLabels" . -}}
{{- end -}}


