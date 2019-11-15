{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mongo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mongo.fullname" -}}
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
{{- define "mongo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "mongo.k8s.labels" -}}
app.kubernetes.io/name: {{ include "mongo.name" . }}
helm.sh/chart: {{ include "mongo.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "mongo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "mongo.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
mongo labels
*/}}
{{- define "mongo.labels" -}}
{{- $app := printf "%s-%s" .Chart.Name "nhs" -}}
app: {{ if .Values.global }}
{{- .Values.global.parent_app | default $app -}}
{{ else }}
{{- $app -}}
{{ end }}
tier: "nhs-db"
{{- end -}}

{{/*
mongo selector
*/}}
{{- define "mongo.selector" -}}
nhsdb: "mongodb"
{{- end -}}

{{/*
Statefulset pod labels
*/}}
{{- define "mongo.pod.labels" -}}
{{ range $k, $v := .Values.pod }}
{{- $k }}: {{ $v }}
{{ end }}
{{- end -}}

{{/*
Inline pod labels
*/}}
{{- define "mongo.pod.labels.inline" -}}
{{ range $k, $v := .Values.pod }}
{{- $k }}={{ printf "%s," $v -}}
{{ end }}
{{- end -}}

{{/*
quote & trim inline pod labels
*/}}
{{- define "mongo.pod.labels.as.parameters" -}}
{{- $t := include "mongo.pod.labels.inline" . }}
{{- $tt := trimSuffix "," $t }}
{{- printf "%s" $tt | quote }}
{{- end -}}
