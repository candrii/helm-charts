{{/*
Generate the full name with prefix
*/}}
{{- define "argocd-victoriametrics-stack.fullname" -}}
{{- printf "%s-%s" .Values.namePrefix .name -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "argocd-victoriametrics-stack.labels" -}}
app.kubernetes.io/managed-by: argocd
app.kubernetes.io/part-of: victoriametrics-stack
{{- end -}}

{{/*
Generate application name with prefix
*/}}
{{- define "argocd-victoriametrics-stack.appName" -}}
{{- printf "%s-%s" $.Values.namePrefix .component -}}
{{- end -}}
