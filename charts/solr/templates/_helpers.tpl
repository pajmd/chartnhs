{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "solr.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "solr.fullname" -}}
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
{{- define "solr.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "solr.k8s.labels" -}}
app.kubernetes.io/name: {{ include "solr.name" . }}
helm.sh/chart: {{ include "solr.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "solr.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "solr.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Create name for hosting app
*/}}
{{- define "solr.hosting.app" -}}
{{- $app := printf "%s-%s" .Chart.Name "nhs" -}}
app: {{ if .Values.global }}
{{- .Values.global.parent_app | default $app -}}
{{ else }}
{{- $app -}}
{{ end }}
{{- end -}}

{{/*
solr labels
*/}}
{{- define "solr.labels" -}}
{{ include "solr.hosting.app" . }}
tier: "solr"
{{- end -}}

{{/*
solr config map name
*/}}
{{- define "solr.config.map.name" -}}
{{- printf "%s-config-map" .Chart.Name }}
{{- end -}}

{{/*
solr service name
*/}}
{{- define "solr.service.name" -}}
{{- printf "%s-svc" .Chart.Name }}
{{- end -}}


{{/*
solr headless service name
*/}}
{{- define "solr.headless.service.name" -}}
{{- printf "%s-headless-service" .Chart.Name }}
{{- end -}}

{{/*
solr pod labels
*/}}
{{- define "solr.pod.labels" -}}
{{ include "solr.labels" . }}
type: "pod"
{{- end -}}

{{/*
Solr zookeeper name
*/}}
{{- define "solr.zookeeper.name" }}
{{- printf "zookeeper" }}
{{- end -}}

{{/*
Solr zookeeper service name
*/}}
{{- define "solr.zookeeper.service.name" }}
{{- printf "%s-headless-service" (include "solr.zookeeper.name" .) }}
{{- end -}}


{{/*
solr image repo
*/}}
{{- define "solr.image.repo" -}}
{{ if .Values.global }}
{{- .Values.global.repo | default .Values.image.repo -}}
{{ else }}
{{- .Values.image.repo -}}
{{ end }}
{{- end -}}
