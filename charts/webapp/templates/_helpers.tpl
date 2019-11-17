{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "webapp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "webapp.fullname" -}}
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
{{- define "webapp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "webapp.k8s.labels" -}}
app.kubernetes.io/name: {{ include "webapp.name" . }}
helm.sh/chart: {{ include "webapp.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "webapp.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "webapp.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
web app labels
*/}}
{{- define "webapp.labels" -}}
{{- $app := printf "%s-%s" .Chart.Name "nhs" -}}
app: {{ if .Values.global }}
{{- .Values.global.parent_app | default $app -}}
{{ else }}
{{- $app -}}
{{ end }}
tier: "nhs-server"
{{- end -}}

{{/*
web app selector
*/}}
{{- define "webapp.selector" -}}
app: nhsserver
{{- end -}}

{{/*
web app image repo
*/}}
{{- define "webapp.image.repo" -}}
{{ if .Values.global }}
{{- .Values.global.repo | default .Values.image.repo -}}
{{ else }}
{{- .Values.image.repo -}}
{{ end }}
{{- end -}}

{{/*
webapp mongo name
*/}}
{{- define "webapp.mongo.pod.name" }}
{{- printf "%s" "mongo" }}
{{- end -}}

{{/*
webapp mongo service name
*/}}
{{- define "webapp.mongo.service.name" }}
{{- printf "%s" "mongo" }}
{{- end -}}

{{- define "webapp.build.mongo_host" -}}
{{ $val := .Values }}
{{- range $i, $e := until ( int .Values.mongo.replicaCount ) -}}
{{- printf "%s-%d.%s.%s," $val.mongo.podName $i $val.mongo.serviceName $val.mongo.domain -}} 
{{ end -}}
{{- end -}}

{{/*
Webapp mongo host
*/}}
{{- define "webapp.mongo_host" -}}
{{ include "webapp.build.mongo_host" . | trimSuffix "," }}
{{- end -}}


{{/*
Web app mongo replicaset 
*/}}
{{- define "webapp.mongo_replica" -}}
{{ if .Values.global }}
{{- .Values.global.mongo_replicaset | default .Values.mongo_replicaset -}}
{{ else }}
{{- .Values.mongo_replicaset -}}
{{ end }}
{{- end -}}

{{/*
Web app solr host
*/}}
{{- define "webapp.solr_host" -}}
{{ if .Values.global }}
{{- .Values.global.solr_host | default .Values.solr_host -}}
{{ else }}
{{- .Values.solr_host -}}
{{ end }}
{{- end -}}
