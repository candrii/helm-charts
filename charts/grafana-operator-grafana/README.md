# grafana-operator-grafana

Helm chart for deploying Grafana using the [Grafana Operator](https://github.com/grafana/grafana-operator) CRD.

## Description

Creates a `Grafana` custom resource that the Grafana Operator manages to deploy and configure a Grafana instance.

## Requirements

- Kubernetes 1.21+
- [Grafana Operator](https://grafana.github.io/grafana-operator/) v5.x installed

## Installation

```bash
helm install grafana candrii/grafana-operator-grafana -n monitoring
```

## Configuration

### Basic

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `enabled` | bool | `true` | Enable/disable Grafana deployment |
| `name` | string | `grafana` | Grafana instance name |
| `namespace` | string | `""` | Namespace (defaults to release namespace) |
| `version` | string | `11.4.0` | Grafana container image version |
| `labels` | object | `{dashboards: "grafana"}` | Labels for the Grafana CR |

### Instance Selector

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `instanceSelector.matchLabels` | object | `{dashboards: "grafana"}` | Label selector for dashboards/datasources |

### Grafana Configuration (grafana.ini)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `config.log.mode` | string | `console` | Log output mode |
| `config.log.level` | string | `info` | Log level |
| `config.server.root_url` | string | `""` | Root URL for Grafana |
| `config.auth.disable_login_form` | string | `false` | Disable login form |
| `config.auth.anonymous.enabled` | string | `false` | Enable anonymous access |
| `config.security.admin_user` | string | `""` | Admin username |
| `config.security.admin_password` | string | `""` | Admin password |

### Deployment

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `deployment.replicas` | int | `1` | Number of replicas |
| `deployment.resources.requests.cpu` | string | `100m` | CPU request |
| `deployment.resources.requests.memory` | string | `256Mi` | Memory request |
| `deployment.resources.limits.memory` | string | `512Mi` | Memory limit |
| `deployment.nodeSelector` | object | `{}` | Node selector |
| `deployment.tolerations` | list | `[]` | Tolerations |
| `deployment.affinity` | object | `{}` | Affinity rules |
| `deployment.env` | list | `[]` | Environment variables |

### Service

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `service.type` | string | `ClusterIP` | Service type |
| `service.port` | int | `3000` | Service port |
| `service.annotations` | object | `{}` | Service annotations |

### Ingress

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `ingress.enabled` | bool | `false` | Enable ingress |
| `ingress.className` | string | `""` | Ingress class name |
| `ingress.hostname` | string | `""` | Hostname |
| `ingress.path` | string | `/` | Path |
| `ingress.pathType` | string | `Prefix` | Path type |
| `ingress.tls` | bool | `false` | Enable TLS |
| `ingress.tlsSecretName` | string | `""` | TLS secret name |
| `ingress.annotations` | object | `{}` | Ingress annotations |

### Persistence

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `persistence.enabled` | bool | `false` | Enable persistence |
| `persistence.size` | string | `10Gi` | Storage size |
| `persistence.storageClassName` | string | `""` | Storage class |
| `persistence.accessModes` | list | `[ReadWriteOnce]` | Access modes |

### External Grafana

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `external.enabled` | bool | `false` | Manage external Grafana instance |
| `external.url` | string | `""` | External Grafana URL |
| `external.adminCredentialsSecret` | string | `""` | Secret with admin credentials |

## Examples

### Basic Deployment

```yaml
name: grafana
namespace: monitoring
version: "11.4.0"

config:
  server:
    root_url: "https://grafana.example.com"

deployment:
  replicas: 1
  resources:
    requests:
      cpu: 100m
      memory: 256Mi
```

### With Ingress and TLS

```yaml
name: grafana
namespace: monitoring

ingress:
  enabled: true
  className: nginx
  hostname: grafana.example.com
  tls: true
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod

config:
  server:
    root_url: "https://grafana.example.com"
```

### External Grafana (GitOps for existing instance)

```yaml
name: grafana-external
namespace: monitoring

external:
  enabled: true
  url: "https://grafana.example.com"
  adminCredentialsSecret: grafana-admin-credentials

instanceSelector:
  matchLabels:
    dashboards: "grafana-external"
```

### With Persistence

```yaml
name: grafana
namespace: monitoring

persistence:
  enabled: true
  size: 20Gi
  storageClassName: fast-ssd
```

### With OAuth (Authentik)

```yaml
name: grafana
namespace: monitoring

config:
  server:
    root_url: "https://grafana.example.com"
  auth:
    disable_login_form: "true"
  auth.generic_oauth:
    enabled: "true"
    name: "Authentik"
    client_id: "grafana"
    scopes: "openid profile email"
    auth_url: "https://auth.example.com/application/o/authorize/"
    token_url: "https://auth.example.com/application/o/token/"
    api_url: "https://auth.example.com/application/o/userinfo/"
    role_attribute_path: "contains(groups[*], 'Grafana Admins') && 'Admin' || 'Viewer'"

deployment:
  env:
    - name: GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET
      valueFrom:
        secretKeyRef:
          name: grafana-oauth
          key: client-secret
```
