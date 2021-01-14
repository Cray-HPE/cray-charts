{{/*
A common set of labels to apply to resources.
*/}}
{{- define "spire-intermediate.common-labels" -}}
helm.sh/base-chart: {{ include "spire-intermediate.base-chart" . }}
helm.sh/chart: {{ include "spire-intermediate.chart" .Values.global.chart }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ with .Values.labels -}}
{{ toYaml . -}}
{{- end -}}
{{ if .Values.partitionId -}}
cray.io/partition: {{ .Values.partitionId }}
{{- end -}}
{{- end -}}
