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

{{- define "genericDevicePlugin.selectorLabels" -}}
app.kubernetes.io/name: generic-device-plugin
app.kubernetes.io/component: device-plugin
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: generic-device-plugin
{{- end -}}

{{- define "genericDevicePlugin.podLabels" -}}
{{ include "genericDevicePlugin.selectorLabels" . }}
{{- $parts := splitList "@" .Values.image.tag }}
{{- $digest := trimPrefix "sha256:" (index $parts 1) }}
app.kubernetes.io/version: {{ $digest | trunc 63 | quote }}
{{- end -}}

{{- define "genericDevicePlugin.objectLabels" -}}
{{ include "genericDevicePlugin.podLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "genericDevicePlugin.chartName" . }}
{{- end -}}

{{- define "genericDevicePlugin.chartName" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

