{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cray-nexus.name" -}}
{{- default .Chart.Name (index .Values "sonatype-nexus" "nameOverride") | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cray-nexus.fullname" -}}
{{- if (index .Values "sonatype-nexus" "fullnameOverride") -}}
{{- (index .Values "sonatype-nexus" "fullnameOverride") | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name (index .Values "sonatype-nexus" "nameOverride") -}}
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
{{- define "cray-nexus.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels, including ones compatible with sonatype-nexus chart
*/}}
{{- define "cray-nexus.labels" -}}
app.kubernetes.io/name: {{ include "cray-nexus.name" . }}
helm.sh/chart: {{ include "cray-nexus.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app: {{ template "cray-nexus.name" . }}
fullname: {{ template "cray-nexus.fullname" . }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- end -}}

{{/*  Manage the labels for each entity  */}}
{{- define "nexus.labels" -}}
app: {{ template "nexus.name" . }}
fullname: {{ template "nexus.fullname" . }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- end -}}
