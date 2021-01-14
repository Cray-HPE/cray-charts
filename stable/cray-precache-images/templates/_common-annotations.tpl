{{- /*
Copyright 2020 Hewlett Packard Enterprise Development LP
*/ -}}
{{- define "cray-precache-images.common-annotations" -}}
cray.io/service: {{ include "cray-precache-images.name" . }}
{{ with .Values.annotations -}}
{{ toYaml . -}}
{{- end -}}
{{- end -}}
