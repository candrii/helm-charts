# grafana-operator-grafana

Helm chart for deploying Grafana using the [Grafana Operator](https://github.com/grafana/grafana-operator) CRD.

## Description

Creates a `Grafana` custom resource (`grafana.integreatly.org/v1beta1`) that the Grafana Operator manages to deploy and configure a Grafana instance.

This chart maps directly to the official Grafana Operator API, making all upstream configuration options available.

## Requirements

- Kubernetes 1.21+
- [Grafana Operator](https://grafana.github.io/grafana-operator/) v5.x installed

## Installation

```bash
helm install grafana candrii/grafana-operator-grafana -n monitoring
```

## API Reference

This chart's values map directly to the [Grafana CRD spec](https://grafana.github.io/grafana-operator/docs/api/).

### Top-Level Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `enabled` | bool | `true` | Enable/disable Grafana CR creation |
| `metadata.name` | string | `""` | CR name (defaults to release name) |
| `metadata.namespace` | string | `""` | Namespace (defaults to release namespace) |
| `metadata.labels` | object | `{}` | Additional labels |
| `metadata.annotations` | object | `{}` | Additional annotations |
| `version` | string | `"11.4.0"` | Grafana container image version |
| `instanceSelector` | object | `{matchLabels: {dashboards: "grafana"}}` | Label selector for dashboards/datasources |
| `disableDefaultAdminSecret` | bool | `false` | Disable default admin credentials |
| `disableDefaultSecurityContext` | string | `""` | Disable security context (Pod/Container/All) |
| `suspend` | bool | `false` | Pause reconciliation |

### Config (grafana.ini)

Maps to `spec.config` - nested map for grafana.ini sections:

```yaml
config:
  log:
    mode: "console"
    level: "info"
  server:
    root_url: "https://grafana.example.com"
  auth:
    disable_login_form: "true"
  auth.generic_oauth:
    enabled: "true"
    # ... other OAuth settings
```

### Deployment

Maps to `spec.deployment` (DeploymentV1):

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `deployment.metadata.labels` | object | `{}` | Deployment labels |
| `deployment.metadata.annotations` | object | `{}` | Deployment annotations |
| `deployment.spec.replicas` | int | `1` | Number of replicas |
| `deployment.spec.strategy` | object | `{}` | Update strategy |
| `deployment.spec.template.metadata` | object | `{}` | Pod metadata |
| `deployment.spec.template.spec.securityContext` | object | See values | Pod security context |
| `deployment.spec.template.spec.containers` | list | See values | Container specs |
| `deployment.spec.template.spec.volumes` | list | `[]` | Pod volumes |
| `deployment.spec.template.spec.nodeSelector` | object | `{}` | Node selector |
| `deployment.spec.template.spec.tolerations` | list | `[]` | Tolerations |
| `deployment.spec.template.spec.affinity` | object | `{}` | Affinity rules |
| `deployment.spec.template.spec.initContainers` | list | `[]` | Init containers |

### Service

Maps to `spec.service` (ServiceV1):

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `service.metadata.labels` | object | `{}` | Service labels |
| `service.metadata.annotations` | object | `{}` | Service annotations |
| `service.spec` | object | See values | corev1.ServiceSpec |

### Ingress

Maps to `spec.ingress` (IngressNetworkingV1):

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `ingress.enabled` | bool | `false` | Enable ingress |
| `ingress.metadata.labels` | object | `{}` | Ingress labels |
| `ingress.metadata.annotations` | object | `{}` | Ingress annotations |
| `ingress.spec.ingressClassName` | string | `""` | Ingress class |
| `ingress.spec.rules` | list | `[]` | Ingress rules |
| `ingress.spec.tls` | list | `[]` | TLS configuration |

### PersistentVolumeClaim

Maps to `spec.persistentVolumeClaim` (PersistentVolumeClaimV1):

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `persistentVolumeClaim.enabled` | bool | `false` | Enable PVC |
| `persistentVolumeClaim.metadata` | object | `{}` | PVC metadata |
| `persistentVolumeClaim.spec` | object | See values | PVC spec |

### ServiceAccount

Maps to `spec.serviceAccount` (ServiceAccountV1):

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `serviceAccount.enabled` | bool | `true` | Enable service account |
| `serviceAccount.metadata.name` | string | `""` | SA name |
| `serviceAccount.metadata.labels` | object | `{}` | SA labels |
| `serviceAccount.metadata.annotations` | object | `{}` | SA annotations |
| `serviceAccount.imagePullSecrets` | list | `[]` | Image pull secrets |
| `serviceAccount.automountServiceAccountToken` | bool | `true` | Mount SA token |

### External Grafana

Maps to `spec.external` - manage existing Grafana instances:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `external.enabled` | bool | `false` | Enable external mode |
| `external.url` | string | `""` | External Grafana URL |
| `external.apiKey` | object | `{}` | API key secret reference |
| `external.adminUser` | object | `{}` | Admin user secret reference |
| `external.adminPassword` | object | `{}` | Admin password secret reference |
| `external.tls` | object | `{}` | TLS configuration |

### Client

Maps to `spec.client` - operator-to-Grafana API settings:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `client.useKubeAuth` | bool | - | Use Kubernetes auth |
| `client.timeout` | int | - | Timeout in seconds |
| `client.preferIngress` | bool | - | Prefer ingress for API |
| `client.headers` | object | - | Custom HTTP headers |
| `client.tls` | object | - | TLS configuration |

### Route (OpenShift)

Maps to `spec.route` (RouteOpenshiftV1):

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `route.enabled` | bool | `false` | Enable OpenShift Route |
| `route.metadata` | object | `{}` | Route metadata |
| `route.spec` | object | `{}` | Route spec |

### HTTPRoute (Gateway API)

Maps to `spec.httpRoute` (HTTPRouteV1):

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `httpRoute.enabled` | bool | `false` | Enable Gateway API HTTPRoute |
| `httpRoute.metadata` | object | `{}` | HTTPRoute metadata |
| `httpRoute.spec` | object | `{}` | HTTPRoute spec |

## Examples

### Basic Deployment

```yaml
metadata:
  name: grafana
version: "11.4.0"

config:
  server:
    root_url: "https://grafana.example.com"

instanceSelector:
  matchLabels:
    dashboards: "grafana"
```

### With Ingress

```yaml
ingress:
  enabled: true
  metadata:
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
  spec:
    ingressClassName: nginx
    rules:
      - host: grafana.example.com
        http:
          paths:
            - path: /
              pathType: Prefix
              backend:
                service:
                  name: grafana-service
                  port:
                    number: 3000
    tls:
      - hosts:
          - grafana.example.com
        secretName: grafana-tls
```

### With Persistence

```yaml
persistentVolumeClaim:
  enabled: true
  spec:
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 20Gi
    storageClassName: fast-ssd
```

### External Grafana (GitOps)

```yaml
external:
  enabled: true
  url: "https://grafana.example.com"
  apiKey:
    name: grafana-api-key
    key: token

instanceSelector:
  matchLabels:
    dashboards: "external-grafana"
```

### With OAuth (Authentik)

```yaml
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
  spec:
    template:
      spec:
        containers:
          - name: grafana
            env:
              - name: GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET
                valueFrom:
                  secretKeyRef:
                    name: grafana-oauth
                    key: client-secret
```

## Template Structure

```
templates/
├── _helpers.tpl        # Common helpers and labels
├── _deployment.tpl     # Deployment spec partial
├── _service.tpl        # Service spec partial
├── _ingress.tpl        # Ingress spec partial
├── _pvc.tpl            # PVC spec partial
├── _serviceaccount.tpl # ServiceAccount spec partial
├── _route.tpl          # OpenShift Route spec partial
├── _httproute.tpl      # Gateway API HTTPRoute spec partial
└── grafana.yaml        # Main Grafana CR template
```

## References

- [Grafana Operator GitHub](https://github.com/grafana/grafana-operator)
- [Grafana Operator API Reference](https://grafana.github.io/grafana-operator/docs/api/)
- [Grafana Configuration](https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/)
