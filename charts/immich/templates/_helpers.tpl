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
app.kubernetes.io/name: immich
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: immich
{{- end -}}

{{/*
Common pod labels - includes version information
*/}}
{{- define "common.podLabels" -}}
app.kubernetes.io/name: immich
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.server.image.tag | quote }}
app.kubernetes.io/part-of: immich
{{- end -}}

{{/*
Legacy common labels - for compatibility
*/}}
{{- define "common.labels" -}}
{{- include "common.podLabels" . -}}
{{- end -}}

{{/*
Library component labels - for shared storage
*/}}
{{- define "immich.library.labels" -}}
app.kubernetes.io/name: immich
app.kubernetes.io/component: library
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: immich
{{- end -}}
