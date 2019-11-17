{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "scrapy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "scrapy.fullname" -}}
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
{{- define "scrapy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common k8s labels
*/}}
{{- define "scrapy.k8s.labels" -}}
app.kubernetes.io/name: {{ include "scrapy.name" . }}
helm.sh/chart: {{ include "scrapy.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "scrapy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "scrapy.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the job name
*/}}
{{- define "scrapy.job-name" -}}
{{- printf "%s-%s" (include "scrapy.fullname" .) "job" }}
{{- end -}}

{{/*
scrapy labels
*/}}
{{- define "scrapy.labels" -}}
{{- $app := printf "%s-%s" .Chart.Name "nhs" -}}
{{ if .Values.global }}
{{- printf "app: %s" .Values.global.parent_app | default $app -}}
{{ else }}
{{- printf "app: %s" $app -}}
{{ end }}
tier: "scrapy"
{{- end -}}

{{/*
scrapy image repo
*/}}
{{- define "scrapy.image.repo" -}}
{{ if .Values.global }}
{{- .Values.global.repo | default .Values.image.repo -}}
{{ else }}
{{- .Values.image.repo -}}
{{ end }}
{{- end -}}

{{/*
scrapy zookeeper last instance
*/}}
{{- define "scrapy.zookeper.hosts.and.ports" -}}
{{- $val := .Values -}}
{{ range $i, $num := until ( int .Values.zookeeper.replicaCount ) }}
{{- if eq $i (sub $val.zookeeper.replicaCount 1) }}
{{- printf "%s-%d.%s:%s" $val.zookeeper.podName $i $val.zookeeper.service $val.zookeeper.port -}}
{{ else }}
{{- printf "%s-%d.%s:%s," $val.zookeeper.podName $i $val.zookeeper.service $val.zookeeper.port -}}
{{ end }}
{{- end }}
{{- end -}}

{{- define "scrapy.last.zookeper.instance" }}
{{- $last := sub .Values.zookeeper.replicaCount 1 }}
{{- printf "%s-%d.%s" .Values.zookeeper.podName $last $.Values.zookeeper.service }}
{{- end -}}