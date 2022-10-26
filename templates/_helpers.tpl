{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "tinode.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tinode.fullname" -}}
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
{{- define "tinode.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tinode.labels" -}}
helm.sh/chart: {{ include "tinode.chart" . }}
{{ include "tinode.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tinode.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tinode.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "tinode.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tinode.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Database socket string host:port
Usage:
{{ include "tinode.socket.string" . }}
*/}}
{{- define "tinode.socket.string" -}}
    {{- if and .Values.listenAddress .Values.listenPort -}}
        {{- printf "%s:%s" .Values.listenAddress (.Values.listenPort | toString) }}
    {{- else if .Values.listenAddress }}
        {{- printf "%s:6060" .Values.listenAddress }}
    {{- else if .Values.listenPort }}
        {{- printf ":%s" (.Values.listenPort | toString) }}
    {{- else }}
        {{- printf ":6060" }}
    {{- end }}
{{- end -}}