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

{{- define "cyberchef.selectorLabels" -}}
app.kubernetes.io/name: cyberchef
app.kubernetes.io/component: frontend
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: cyberchef
{{- end -}}

{{- define "cyberchef.podLabels" -}}
{{ include "cyberchef.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
{{- end -}}

{{- define "cyberchef.objectLabels" -}}
{{ include "cyberchef.podLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "cyberchef.chartName" . }}
{{- end -}}

{{- define "cyberchef.chartName" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
