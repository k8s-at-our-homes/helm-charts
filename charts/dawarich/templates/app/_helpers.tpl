{{/*
Backend (main dawarich app) component labels - selector labels (immutable, no version)
*/}}
{{- define "dawarich.backend.selectorLabels" -}}
app.kubernetes.io/name: dawarich
app.kubernetes.io/component: backend
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: dawarich
{{- end -}}

{{/*
Backend (main dawarich app) component labels - pod labels (with version)
*/}}
{{- define "dawarich.backend.podLabels" -}}
app.kubernetes.io/name: dawarich
app.kubernetes.io/component: backend
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.app.image.tag | quote }}
app.kubernetes.io/part-of: dawarich
{{- end -}}

{{/*
Backend (main dawarich app) component labels - object labels
*/}}
{{- define "dawarich.backend.objectLabels" -}}
app.kubernetes.io/name: dawarich
app.kubernetes.io/component: backend
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.app.image.tag | quote }}
app.kubernetes.io/part-of: dawarich
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "dawarich.chartName" . }}
{{- end -}}

{{- define "dawarich.env" -}}
# defaults
- name: SELF_HOSTED
  value: 'true'
- name: APPLICATION_PROTOCOL
  value: http
- name: RAILS_ENV
  value: production
- name: RAILS_LOG_TO_STDOUT
  value: 'true'
- name: SIDEKIQ_EMBEDDED
  value: 'true'
- name: WEB_CONCURRENCY
  value: '0' # Must be 0 with SIDEKIQ_EMBEDDED set to 'true'
- name: SECRET_KEY_BASE
  valueFrom:
    secretKeyRef:
      name: {{ include "common.fullname" . }}-secret
      key: secret-key-base
- name: APPLICATION_HOSTS
  value: {{ include "dawarich.hosts" . | quote }}
- name: DOMAIN
  value: {{ .Values.hostname | quote }}
# config
- name: MIN_MINUTES_SPENT_IN_CITY
  value: {{ .Values.config.minimumMinutesSpentInCity | quote }}
- name: TIME_ZONE
  value: {{ .Values.config.timezone }}
- name: ALLOW_EMAIL_PASSWORD_REGISTRATION
  value: {{ .Values.config.allowEmailPasswordRegistration | quote }}
# OIDC Auth
{{- if .Values.config.oidc.enabled }}
- name: OIDC_AUTO_REGISTER
  value: {{ .Values.config.oidc.autoRegister | quote }}
{{- with .Values.config.oidc.providerName}}
- name: OIDC_PROVIDER_NAME
  value: {{ . }}
{{- end }}
- name: OIDC_ISSUER
  {{- with .Values.config.oidc.issuerUrl }}
  value: {{ . }}
  {{- end }}
  {{- if not .Values.config.oidc.issuerUrl }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.config.oidc.secretName }}
      key: {{ .Values.config.oidc.secretKeyRef.issuerUrl }}
  {{- end }}
- name: OIDC_REDIRECT_URI
  value: https://{{ .Values.hostname }}/users/auth/openid_connect/callback
- name: OIDC_CLIENT_ID
  {{- with .Values.config.oidc.clientId }}
  value: {{ . }}
  {{- end }}
  {{- if not .Values.config.oidc.clientId }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.config.oidc.secretName }}
      key: {{ .Values.config.oidc.secretKeyRef.clientId }}
  {{- end }}
- name: OIDC_CLIENT_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ .Values.config.oidc.secretName }}
      key: {{ .Values.config.oidc.secretKeyRef.clientSecret }}
{{- end }}
# photon
- name: STORE_GEODATA
  value: 'true'
{{- if .Values.photon.enabled }}
- name: PHOTON_API_HOST
  value: {{ template "common.fullname" . }}-photon-gateway:8080
- name: PHOTON_API_USE_HTTPS
  value: 'false'
- name: PHOTON_API_LANGUAGE
  value: default
{{- end }}
# Database
- name: DATABASE_HOST
  valueFrom:
    secretKeyRef:
      name: {{ .Values.database.clusterName }}-app
      key: host
- name: DATABASE_NAME
  valueFrom:
    secretKeyRef:
      name: {{ .Values.database.clusterName }}-app
      key: dbname
- name: DATABASE_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ .Values.database.clusterName }}-app
      key: username
- name: DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.database.clusterName }}-app
      key: password
# Redis
- name: REDIS_URL
  value: redis://{{ .Release.Name }}-redis:{{ .Values.redis.redis.port }}
{{- end }}
