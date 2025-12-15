{{/*
Deployment spec for Grafana CRD
*/}}
{{- define "grafana.deployment" -}}
deployment:
  {{- with .Values.deployment.metadata }}
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
    {{- with .Values.deployment.spec.replicas }}
    replicas: {{ . }}
    {{- end }}
    {{- with .Values.deployment.spec.strategy }}
    strategy:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    template:
      {{- with .Values.deployment.spec.template.metadata }}
      {{- if or .labels .annotations }}
      metadata:
        {{- with .labels }}
        labels:
          {{- toYaml . | nindent 10 }}
        {{- end }}
        {{- with .annotations }}
        annotations:
          {{- toYaml . | nindent 10 }}
        {{- end }}
      {{- end }}
      {{- end }}
      spec:
        {{- with .Values.deployment.spec.template.spec.securityContext }}
        securityContext:
          {{- toYaml . | nindent 10 }}
        {{- end }}
        {{- with .Values.deployment.spec.template.spec.nodeSelector }}
        nodeSelector:
          {{- toYaml . | nindent 10 }}
        {{- end }}
        {{- with .Values.deployment.spec.template.spec.tolerations }}
        tolerations:
          {{- toYaml . | nindent 10 }}
        {{- end }}
        {{- with .Values.deployment.spec.template.spec.affinity }}
        affinity:
          {{- toYaml . | nindent 10 }}
        {{- end }}
        {{- with .Values.deployment.spec.template.spec.volumes }}
        volumes:
          {{- toYaml . | nindent 10 }}
        {{- end }}
        {{- with .Values.deployment.spec.template.spec.initContainers }}
        initContainers:
          {{- toYaml . | nindent 10 }}
        {{- end }}
        containers:
          {{- range .Values.deployment.spec.template.spec.containers }}
          - name: {{ .name }}
            {{- with .securityContext }}
            securityContext:
              {{- toYaml . | nindent 14 }}
            {{- end }}
            {{- with .resources }}
            resources:
              {{- toYaml . | nindent 14 }}
            {{- end }}
            {{- with .env }}
            env:
              {{- toYaml . | nindent 14 }}
            {{- end }}
            {{- with .volumeMounts }}
            volumeMounts:
              {{- toYaml . | nindent 14 }}
            {{- end }}
          {{- end }}
{{- end }}
