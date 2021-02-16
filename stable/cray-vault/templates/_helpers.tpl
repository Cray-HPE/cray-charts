{{/*
Use the vault-operator-* helpers, define others here as needed
*/}}

{{- define "cray-vault.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

 {{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cray-vault.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "cray-vault.etcdName" -}}
{{- printf "%s-etcd" (include "cray-vault.name" .) -}}
{{- end -}}
