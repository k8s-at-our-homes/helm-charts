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

{{- define "common.selectorLabels" -}}
app.kubernetes.io/name: {{ template "common.name" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ .Chart.Name }}
{{- end -}}

{{- define "common.labels" -}}
app.kubernetes.io/name: {{ template "common.name" . }}
helm.sh/chart: {{ include "chartName" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.app.image.tag | quote }}
app.kubernetes.io/part-of: {{ .Chart.Name }}
{{- end -}}

{{- define "dawarich.hosts" -}}
{{- $internal := list (include "common.fullname" .) (printf "%s.%s" (include "common.fullname" .) .Release.Namespace) (printf "%s.%s.svc.cluster.local" (include "common.fullname" .) .Release.Namespace) -}}
{{- $ingress := list -}}
{{- $routes := list -}}
{{- if .Values.route.enabled -}}
{{- $routes = .Values.route.hostnames -}}
{{- end -}}
{{- if .Values.ingress.enabled -}}
{{- $ingress = list .Values.ingress.domain -}}
{{- end -}}
{{- $all := concat $internal $routes $ingress -}}
{{- $hosts := $all | uniq | join "," -}}
{{- $hosts -}}
{{- end -}}

{{- define "dawarich.env" -}}
# config
- name: MIN_MINUTES_SPENT_IN_CITY
  value: {{ .Values.config.minimumMinutesSpentInCity | quote }}
- name: TIME_ZONE
  value: {{ .Values.config.timezone }}
# defaults
- name: SELF_HOSTED
  value: 'true'
- name: APPLICATION_PROTOCOL
  value: http
- name: RAILS_ENV
  value: 'development'
- name: APPLICATION_HOSTS
  value: {{ include "dawarich.hosts" . | quote }}
# photon
- name: 'STORE_GEODATA'
  value: {{ if or .Values.photon.deploy .Values.envoyProxy.enabled }}'false'{{ else }}'true'{{ end }}
{{- if .Values.envoyProxy.enabled }}
- name: PHOTON_API_HOST
  value: {{ template "common.fullname" . }}-envoy-proxy:8080
- name: PHOTON_API_USE_HTTPS
  value: 'false'
{{- else if not .Values.photon.deploy }}
- name: PHOTON_API_HOST
  value: photon.komoot.io
- name: PHOTON_API_USE_HTTPS
  value: 'true'
{{- else }}
- name: PHOTON_API_HOST
  value: {{ template "common.fullname" . }}-photon:2322
- name: PHOTON_API_USE_HTTPS
  value: 'false'
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
  value: redis://{{ .Release.Name }}-redis-master
{{- end }}