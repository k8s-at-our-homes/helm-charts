{{- define "mealie.database.selectorLabels" -}}
app.kubernetes.io/name: postgresql
app.kubernetes.io/component: database
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: mealie
{{- end -}}

{{- define "mealie.database.podLabels" -}}
{{ include "mealie.database.selectorLabels" . }}
{{- $version := "unknown" -}}
{{- with .Values.database }}
	{{- with .image }}
		{{- with .tag }}
			{{- $version = . -}}
		{{- end }}
	{{- end }}
{{- end }}
app.kubernetes.io/version: {{ $version | quote }}
{{- end -}}

{{- define "mealie.database.objectLabels" -}}
{{ include "mealie.database.podLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "mealie.chartName" . }}
{{- end -}}