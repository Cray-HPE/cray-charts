{{/*
Path for mounting regos in test pod
*/}}

{{- define "gatekeeper-policy-library.regos" -}}
{{- printf "%s..data" .Values.mountpath}}
{{- end -}}
