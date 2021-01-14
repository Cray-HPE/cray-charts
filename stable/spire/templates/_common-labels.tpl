{{/*
A common set of labels to apply to resources.
*/}}
{{- define "spire.common-labels" -}}
helm.sh/base-chart: {{ include "spire.base-chart" . }}
helm.sh/chart: {{ include "spire.chart" .Values.global.chart }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ with .Values.labels -}}
{{ toYaml . -}}
{{- end -}}
{{ if .Values.partitionId -}}
cray.io/partition: {{ .Values.partitionId }}
{{- end -}}
{{- end -}}
