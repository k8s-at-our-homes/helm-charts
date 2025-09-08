{{/*
Resolver component labels - selector labels (immutable, no version)
*/}}
{{- define "adguard.resolver.selectorLabels" -}}
app.kubernetes.io/name: adguard
app.kubernetes.io/component: resolver
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: adguard
{{- end -}}

{{/*
Resolver component labels - pod labels (with version)
*/}}
{{- define "adguard.resolver.podLabels" -}}
app.kubernetes.io/name: adguard
app.kubernetes.io/component: resolver
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.adguard.image.tag | quote }}
app.kubernetes.io/part-of: adguard
{{- end -}}