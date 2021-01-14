{{/*
Use the istio-* helpers, define others here as needed
*/}}

{{/*
Get an image prefix
*/}}
{{- define "cray-istio.image-prefix" -}}
{{- if .Values.imagesHost -}}
{{- printf "%s/" .Values.imagesHost -}}
{{- else -}}
{{- printf "" -}}
{{- end -}}
{{- end -}}
