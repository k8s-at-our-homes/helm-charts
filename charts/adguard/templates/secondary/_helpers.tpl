{{/*
Resolver component labels - selector labels (immutable, no version)
*/}}
{{- define "adguard.resolver.selectorLabels" -}}
app.kubernetes.io/component: resolver
{{ include "adguard.chartLabels" . }}
{{- end -}}

{{/*
Resolver component labels - pod labels (with version)
*/}}
{{- define "adguard.resolver.podLabels" -}}
{{ include "adguard.resolver.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.adguard.image.tag | quote }}
{{- end -}}

{{- define "adguard.resolver.objectLabels" -}}
{{ include "adguard.resolver.podLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "adguard.chartName" . }}
{{- end -}}