{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "piper.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "piper.fullname" -}}
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
{{- define "piper.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "piper.k8s.labels" -}}
app.kubernetes.io/name: {{ include "piper.name" . }}
helm.sh/chart: {{ include "piper.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "piper.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "piper.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Create the mongo deployment name
*/}}
{{- define "piper.mongo.deployment-name" -}}
{{- printf "%s-%s" (include "piper.fullname" .) "mongo-deployment" }}
{{- end -}}

{{/*
Create the solr deployment name
*/}}
{{- define "piper.solr.deployment-name" -}}
{{- printf "%s-%s" (include "piper.fullname" .) "solr-deployment" }}
{{- end -}}

{{/*
mongo & solr main app
*/}}
{{- define "piper.main.app.labels" -}}
{{- $app := printf "%s-%s" .Chart.Name "nhs" -}}
{{ if .Values.global }}
{{- printf "app: %s" .Values.global.parent_app | default $app -}}
{{ else }}
{{- printf "app: %s" $app -}} 
{{ end }}
{{- end -}}

{{/*
mongo piper labels
*/}}
{{- define "piper.mongo.labels" -}}
tier: "piper"
type: "mongo"
{{- end -}}

{{/*
main app & mongo piper labels
*/}}
{{- define "piper.mongo.main.app.labels" -}}
{{ include "piper.main.app.labels" . }}
{{ include "piper.mongo.labels" . }}
{{- end -}}

{{/*
solr piper labels
*/}}
{{- define "piper.solr.labels" -}}
tier: "piper"
type: "solr"
{{- end -}}

{{/*
main app & solr piper labels
*/}}
{{- define "piper.solr.main.app.labels" -}}
{{ include "piper.main.app.labels" . }}
{{ include "piper.solr.labels" . }}
{{- end -}}

{{/*
piper image repo
*/}}
{{- define "piper.image.repo" -}}
{{ if .Values.global }}
{{- .Values.global.repo | default .Values.image.repo -}}
{{ else }}
{{- .Values.image.repo -}}
{{ end }}
{{- end -}}

{{/*
piper mongo host:port
*/}}
{{- define "piper.mongo.hosts.and.ports" -}}
{{- $val := .Values -}}
{{ range $i, $num := until ( int .Values.mongo.replicaCount ) }}
{{- if eq $i (sub $val.mongo.replicaCount 1) }}
{{- printf "%s-%d.%s.%s:%s" $val.mongo.podName $i $val.mongo.service $val.mongo.domain $val.mongo.port -}}
{{ else }}
{{- printf "%s-%d.%s.%s:%s," $val.mongo.podName $i $val.mongo.service $val.mongo.domain $val.mongo.port -}}
{{ end }}
{{- end }}
{{- end -}}
