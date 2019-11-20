{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kafka.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kafka.fullname" -}}
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
{{- define "kafka.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "kafka.k8s.labels" -}}
app.kubernetes.io/name: {{ include "kafka.name" . }}
helm.sh/chart: {{ include "kafka.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "kafka.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "kafka.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the kafka statefulset name
*/}}
{{- define "kafka.statefulset.name" -}}
{{- printf "%s" .Chart.Name }}
{{- end -}}

{{/*
kafka pod labels
*/}}
{{- define "kafka.pod.labels" -}}
{{ include "kafka.selector" .}}
type: pod
{{- end -}}

{{/*
Create the kafka service name
*/}}
{{- define "kafka.service.name" -}}
{{- printf "%s-svc" .Chart.Name }}
{{- end -}}

{{/*
kafka headless service name
*/}}
{{- define "kafka.headless.service.name" -}}
{{- printf "%s-headless-service" .Chart.Name }}
{{- end -}}

{{/*
Create name for hosting app
*/}}
{{- define "kafka.hosting.app" -}}
{{- $app := printf "%s-%s" .Chart.Name "nhs" -}}
app: {{ if .Values.global }}
{{- .Values.global.parent_app | default $app -}}
{{ else }}
{{- $app -}}
{{ end }}
{{- end -}}

{{/*
kafka labels
*/}}
{{- define "kafka.labels" -}}
{{ include "kafka.hosting.app" . }}
tier: "kafka"
{{- end -}}

{{/*
kafka selector
*/}}
{{- define "kafka.selector" -}}
queueManager: "kafka"
{{ include "kafka.hosting.app" . }}
{{- end -}}

