{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cray-ceph-csi-rbd.fullname" -}}
{{- if (index .Values "ceph-csi-rbd" "fullnameOverride") -}}
{{- (index .Values "ceph-csi-rbd" "fullnameOverride") | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name (index .Values "ceph-csi-rbd" "nameOverride") -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .ReleaseName $name |trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Use the ceph-csi-rbd-* helpers, define others here as needed
*/}}

{{/*
Get an image prefix
*/}}
{{- define "cray-ceph-csi-rbd.image-prefix" -}}
{{- if .Values.imagesHost -}}
{{- printf "%s/" .Values.imagesHost -}}
{{- else -}}
{{- printf "" -}}
{{- end -}}
{{- end -}}
