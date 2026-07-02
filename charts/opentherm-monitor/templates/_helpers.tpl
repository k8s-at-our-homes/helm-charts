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

{{- define "openthermMonitor.chartName" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "openthermMonitor.selectorLabels" -}}
app.kubernetes.io/name: opentherm-monitor
app.kubernetes.io/component: monitor
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: opentherm-monitor
{{- end -}}

{{- define "openthermMonitor.podLabels" -}}
{{ include "openthermMonitor.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
{{- end -}}

{{- define "openthermMonitor.objectLabels" -}}
{{ include "openthermMonitor.podLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "openthermMonitor.chartName" . }}
{{- end -}}
