{{- /*
Copyright 2020 Hewlett Packard Enterprise Development LP
*/ -}}
{{- define "cray-precache-images.pod-annotations" -}}
{{ if .Values.podAnnotations -}}
{{ with .Values.podAnnotations -}}
{{ toYaml . -}}
{{- end -}}
{{- end -}}
{{- end -}}
