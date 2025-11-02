{{/* Define the base name */}}
{{- define "app.name" -}}
{{- if .Values.nameOverride }}
{{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- printf "%s-%s" .Chart.Name .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end }}

{{/* Define the full name - Defined but not used */}}
{{- define "app.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "app.name" .) .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end }}

{{/* Define common metadata labels */}}
{{- define "app.labels" -}}
app.kubernetes.io/name: {{ include "app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- with .Chart.AppVersion }}
app.kubernetes.io/version: {{ . }}
{{- end }}
{{- end }}

{{/*
Define common selector labels with dynamic role.
Usage: include "app.selectorLabels" (dict "role" "app" "context" .)
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" .context }}
app.kubernetes.io/role: {{ .role }}
{{- end }}

{{/* Define db hostname, using the configured value if provided */}}
{{- define "app.database" -}}
{{- if .Values.database.host -}}
{{ .Values.database.host }}
{{- else -}}
{{ printf "%s-db" (include "app.name" .) }}
{{- end -}}
{{- end }}

{{/* Returns the db headless service name */}}
{{- define "app.dbHeadlessServiceName" -}}
{{ include "app.name" . }}-db-headless
{{- end }}

{{/* Returns the db service name */}}
{{- define "app.dbServiceName" -}}
{{- if .Values.db.serviceName -}}
{{ .Values.db.serviceName | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{ include "app.name" . }}-db
{{- end -}}
{{- end }}
