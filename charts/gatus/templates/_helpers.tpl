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
app.kubernetes.io/name: gatus
app.kubernetes.io/component: monitoring
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: gatus
{{- end -}}

{{/*
Common pod labels - includes version information
*/}}
{{- define "common.podLabels" -}}
app.kubernetes.io/name: gatus
app.kubernetes.io/component: monitoring
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Subcharts.gatus.Chart.AppVersion | default "unknown" | quote }}
app.kubernetes.io/part-of: gatus
{{- end -}}

{{/*
Legacy common labels - for compatibility
*/}}
{{- define "common.labels" -}}
{{- include "common.podLabels" . -}}
{{- end -}}
