{{/*
PersistentVolumeClaim spec for Grafana CRD
*/}}
{{- define "grafana.pvc" -}}
persistentVolumeClaim:
  {{- with .Values.persistentVolumeClaim.metadata }}
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
    {{- toYaml .Values.persistentVolumeClaim.spec | nindent 4 }}
{{- end }}
