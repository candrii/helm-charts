# argocd-victoriametrics-stack

ArgoCD meta-chart for deploying the complete VictoriaMetrics observability stack.

## Description

Creates ArgoCD Applications that deploy:
1. VictoriaMetrics Operator (official helm chart)
2. VMSingle (metrics storage)
3. VLSingle (logs storage)
4. VMAuth (authentication proxy)
5. Authentik Remote Cluster (optional RBAC for Authentik)

## Requirements

- Kubernetes 1.21+
- ArgoCD installed

## Deployment Order (Sync Waves)

| Wave | Component | Description |
|------|-----------|-------------|
| -2 | victoria-metrics-operator | Installs CRDs and operator |
| -1 | victoriametrics-vmsingle | Metrics storage |
| -1 | victoriametrics-vlsingle | Logs storage |
| 0 | victoria-metrics-auth | Auth proxy |
| 1 | authentik-remote-cluster | RBAC for Authentik (optional) |

## Configuration

### Global

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `namePrefix` | string | `vm` | Prefix for ArgoCD Application names |
| `project` | string | `default` | ArgoCD project |
| `destinationCluster` | string | `in-cluster` | Target cluster |
| `namespaces.operator` | string | `cluster-operators` | Operator namespace |
| `namespaces.stack` | string | `monitoring` | Stack namespace |

### Components

Each component has:

| Parameter | Type | Description |
|-----------|------|-------------|
| `{component}.enabled` | bool | Enable/disable |
| `{component}.chart.repoURL` | string | OCI or Helm repo URL |
| `{component}.chart.version` | string | Chart version |
| `{component}.syncWave` | string | ArgoCD sync wave |
| `{component}.values` | object | Values to pass to chart |

## Example

```yaml
namePrefix: vm
project: monitoring
destinationCluster: in-cluster

namespaces:
  operator: cluster-operators
  stack: monitoring

operator:
  enabled: true

vmsingle:
  enabled: true

vlsingle:
  enabled: true

vmauth:
  enabled: true
  values:
    config:
      unauthorized_user:
        url_prefix:
          - http://vmsingle-vm.monitoring.svc:8429

authentikRemoteCluster:
  enabled: false
  namespace: authentik-remote
```
