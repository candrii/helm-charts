{{/*
Ingress spec for Grafana CRD
*/}}
{{- define "grafana.ingress" -}}
ingress:
  {{- with .Values.ingress.metadata }}
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
    {{- with .Values.ingress.spec.ingressClassName }}
    ingressClassName: {{ . }}
    {{- end }}
    {{- with .Values.ingress.spec.rules }}
    rules:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.ingress.spec.tls }}
    tls:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.ingress.spec.defaultBackend }}
    defaultBackend:
      {{- toYaml . | nindent 6 }}
    {{- end }}
{{- end }}
