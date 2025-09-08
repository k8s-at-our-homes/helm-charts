{{/*
Resolver component labels - selector labels (immutable, no version)
*/}}
{{- define "adguard.resolver.selectorLabels" -}}
app.kubernetes.io/name: resolver
app.kubernetes.io/component: resolver
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: adguard
{{- end -}}

{{/*
Resolver component labels - pod labels (with version)
*/}}
{{- define "adguard.resolver.podLabels" -}}
app.kubernetes.io/name: resolver
app.kubernetes.io/component: resolver
helm.sh/chart: {{ include "chartName" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.global.image.tag | quote }}
app.kubernetes.io/part-of: adguard
{{- end -}}