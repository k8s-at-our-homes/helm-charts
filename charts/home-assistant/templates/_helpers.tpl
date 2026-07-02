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

{{- define "homeAssistant.selectorLabels" -}}
app.kubernetes.io/name: home-assistant
app.kubernetes.io/component: frontend
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: home-assistant
{{- end -}}

{{- define "homeAssistant.podLabels" -}}
{{ include "homeAssistant.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
{{- end -}}

{{- define "homeAssistant.objectLabels" -}}
{{ include "homeAssistant.podLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "homeAssistant.chartName" . }}
{{- end -}}

{{- define "homeAssistant.chartName" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

