{{/*
Service spec for Grafana CRD
*/}}
{{- define "grafana.service" -}}
service:
  {{- with .Values.service.metadata }}
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
  spec:
    {{- toYaml .Values.service.spec | nindent 4 }}
{{- end }}
