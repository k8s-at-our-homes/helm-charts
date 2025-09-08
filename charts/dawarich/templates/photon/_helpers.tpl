{{/*
Database (Photon) component labels - selector labels (immutable, no version)
*/}}
{{- define "dawarich.photon.selectorLabels" -}}
app.kubernetes.io/name: photon
app.kubernetes.io/component: database
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: dawarich
{{- end -}}

{{/*
Database (Photon) component labels - pod labels (with version)
*/}}
{{- define "dawarich.photon.podLabels" -}}
app.kubernetes.io/name: photon
app.kubernetes.io/component: database
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.photon.image.tag | quote }}
app.kubernetes.io/part-of: dawarich
{{- end -}}