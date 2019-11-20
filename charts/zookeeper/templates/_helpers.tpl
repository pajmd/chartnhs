{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "zookeeper.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "zookeeper.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "zookeeper.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "zookeeper.k8s.labels" -}}
app.kubernetes.io/name: {{ include "zookeeper.name" . }}
helm.sh/chart: {{ include "zookeeper.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "zookeeper.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "zookeeper.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create name for hosting app
*/}}
{{- define "zookeeper.hosting.app" -}}
{{- $app := printf "%s-%s" .Chart.Name "nhs" -}}
app: {{ if .Values.global }}
{{- .Values.global.parent_app | default $app -}}
{{ else }}
{{- $app -}}
{{ end }}
{{- end -}}

{{/*
zookeeper labels
*/}}
{{- define "zookeeper.labels" -}}
{{ include "zookeeper.hosting.app" . }}
tier: "zookeeper"
{{- end -}}


{{/*
zookeeper selector
*/}}
{{- define "zookeeper.selector" -}}
synchronizer: "zookeeper"
{{ include "zookeeper.hosting.app" . }}
{{- end -}}

{{/*
zookeeper service name
*/}}
{{- define "zookeeper.service.name" -}}
{{- printf "%s-service" .Chart.Name }}
{{- end -}}


{{/*
zookeeper headless service name
*/}}
{{- define "zookeeper.headless.service.name" -}}
{{- printf "%s-headless-service" .Chart.Name }}
{{- end -}}

{{/*
zookeeper pod labels: service selector must select pod labels
*/}}
{{- define "zookeeper.pod.labels" -}}
{{ include "zookeeper.labels" .}}
type: pod
synchronizer: "zookeeper"
{{- end -}}