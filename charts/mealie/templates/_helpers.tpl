{{- define "common.name" -}}
{{ .Chart.Name | trunc 63 | trimSuffix "-" }}
{{ end -}}

{{ define "common.fullname" -}}
{{ if contains .Chart.Name .Release.Name -}}
{{ .Release.Name | trunc 63 | trimSuffix "-" }}
{{ else -}}
{{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{ end -}}
{{ end -}}

{{- define "mealie.chartName" -}}
{{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ end -}}

{{- define "mealie.selectorLabels" -}}
app.kubernetes.io/name: mealie
app.kubernetes.io/component: frontend
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: mealie
{{ end -}}

{{- define "mealie.podLabels" -}}
{{ include "mealie.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
{{- end -}}

{{- define "mealie.objectLabels" -}}
{{ include "mealie.podLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "mealie.chartName" . }}
{{- end -}}
