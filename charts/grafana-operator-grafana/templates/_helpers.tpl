{{/*
Expand the name of the chart.
*/}}
{{- define "grafana.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "grafana.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "grafana.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "grafana.labels" -}}
helm.sh/chart: {{ include "grafana.chart" . }}
{{ include "grafana.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "grafana.selectorLabels" -}}
app.kubernetes.io/name: {{ include "grafana.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Grafana CR name
*/}}
{{- define "grafana.crName" -}}
{{- if .Values.metadata.name }}
{{- .Values.metadata.name }}
{{- else }}
{{- include "grafana.fullname" . }}
{{- end }}
{{- end }}

{{/*
Grafana CR namespace
*/}}
{{- define "grafana.namespace" -}}
{{- if .Values.metadata.namespace }}
{{- .Values.metadata.namespace }}
{{- else }}
{{- .Release.Namespace }}
{{- end }}
{{- end }}

{{/*
Service account name
*/}}
{{- define "grafana.serviceAccountName" -}}
{{- if .Values.serviceAccount.metadata.name }}
{{- .Values.serviceAccount.metadata.name }}
{{- else }}
{{- include "grafana.crName" . }}-sa
{{- end }}
{{- end }}

{{/*
Render config map - filters empty sections
*/}}
{{- define "grafana.config" -}}
{{- $config := dict }}
{{- range $section, $values := .Values.config }}
{{- if $values }}
{{- $nonEmpty := dict }}
{{- range $key, $value := $values }}
{{- if $value }}
{{- $_ := set $nonEmpty $key $value }}
{{- end }}
{{- end }}
{{- if $nonEmpty }}
{{- $_ := set $config $section $nonEmpty }}
{{- end }}
{{- end }}
{{- end }}
{{- if $config }}
{{- toYaml $config }}
{{- end }}
{{- end }}

{{/*
Merge metadata labels with common labels
*/}}
{{- define "grafana.metadataLabels" -}}
{{- $labels := include "grafana.labels" . | fromYaml }}
{{- if .Values.metadata.labels }}
{{- $labels = merge .Values.metadata.labels $labels }}
{{- end }}
{{- toYaml $labels }}
{{- end }}
