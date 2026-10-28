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

{{- define "dawarich.chartName" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "dawarich.hosts" -}}
{{- $internal := list (include "common.fullname" .) (printf "%s.%s" (include "common.fullname" .) .Release.Namespace) (printf "%s.%s.svc.cluster.local" (include "common.fullname" .) .Release.Namespace) -}}
{{- $ingress := list -}}
{{- $routes := list -}}
{{- $hostname := list -}}
{{- if .Values.hostname -}}
{{- $hostname = list .Values.hostname -}}
{{- end -}}
{{- if .Values.route.enabled -}}
{{- $routes = .Values.route.hostnames -}}
{{- end -}}
{{- if .Values.ingress.enabled -}}
{{- $ingress = list .Values.ingress.domain -}}
{{- end -}}
{{- $all := concat $internal $routes $ingress $hostname -}}
{{- $hosts := $all | uniq | join "," -}}
{{- $hosts -}}
{{- end -}}

{{- define "dawarich.photonGateway.configDataChecksum" -}}
{{- $cm := include (print $.Template.BasePath "/photon-gateway/configmap.yaml") . | fromYaml -}}
{{- toYaml $cm.data | sha256sum -}}
{{- end -}}
