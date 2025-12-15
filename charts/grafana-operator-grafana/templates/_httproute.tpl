{{/*
HTTPRoute spec for Grafana CRD (Gateway API)
*/}}
{{- define "grafana.httpRoute" -}}
httpRoute:
  {{- with .Values.httpRoute.metadata }}
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
  {{- with .Values.httpRoute.spec }}
  spec:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
