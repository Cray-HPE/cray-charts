{{- /*
Copyright 2020 Hewlett Packard Enterprise Development LP
*/ -}}
{{- define "cray-precache-images.common-labels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{ with .Values.labels -}}
{{ toYaml . -}}
{{- end -}}
{{- end -}}
