{{/*
Route spec for Grafana CRD (OpenShift)
*/}}
{{- define "grafana.route" -}}
route:
  {{- with .Values.route.metadata }}
  {{- if or .labels .annotations }}
  metadata:
    {{- with .labels }}
    labels:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .annotations }}
    annotations:
      {{- toYaml . | nindent 6 }}
    {{- end }}
  {{- end }}
  {{- end }}
  {{- with .Values.route.spec }}
  spec:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
