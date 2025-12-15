{{/*
ServiceAccount spec for Grafana CRD
*/}}
{{- define "grafana.serviceAccount" -}}
serviceAccount:
  metadata:
    name: {{ include "grafana.serviceAccountName" . }}
    {{- with .Values.serviceAccount.metadata.labels }}
    labels:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.serviceAccount.metadata.annotations }}
    annotations:
      {{- toYaml . | nindent 6 }}
    {{- end }}
  {{- with .Values.serviceAccount.imagePullSecrets }}
  imagePullSecrets:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if .Values.serviceAccount.automountServiceAccountToken }}
  automountServiceAccountToken: {{ .Values.serviceAccount.automountServiceAccountToken }}
  {{- end }}
{{- end }}
