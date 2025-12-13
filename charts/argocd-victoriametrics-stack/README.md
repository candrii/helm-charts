# argocd-victoriametrics-stack

ArgoCD meta-chart for deploying the complete VictoriaMetrics observability stack.

## Description

Creates ArgoCD Applications that deploy:
1. VictoriaMetrics Operator (official helm chart)
2. VMSingle (metrics storage)
3. VLSingle (logs storage)
4. VMAuth (authentication proxy)
5. Authentik Gateway (optional SSO)

## Requirements

- Kubernetes 1.21+
- ArgoCD installed
- Git repository for values files

## Deployment Order (Sync Waves)

| Wave | Component | Description |
|------|-----------|-------------|
| -2 | victoria-metrics-operator | Installs CRDs and operator |
| -1 | victoriametrics-vmsingle | Metrics storage |
| -1 | victoriametrics-vlsingle | Logs storage |
| 0 | victoriametrics-vmauth | Auth proxy |
| 1 | victoriametrics-authentik-gateway | SSO (optional) |

## Configuration

### Global

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `namePrefix` | string | `vm` | Prefix for ArgoCD Application names |
| `project` | string | `default` | ArgoCD project |
| `destinationCluster` | string | `in-cluster` | Target cluster |
| `valuesRepo.url` | string | - | Git repo URL for values |
| `valuesRepo.targetRevision` | string | `HEAD` | Git revision |
| `valuesRepo.pathPrefix` | string | `clusters/hub` | Path prefix for values |
| `namespaces.operator` | string | `cluster-operators` | Operator namespace |
| `namespaces.stack` | string | `monitoring` | Stack namespace |

### Components

Each component has:

| Parameter | Type | Description |
|-----------|------|-------------|
| `{component}.enabled` | bool | Enable/disable |
| `{component}.chart.repository` | string | Chart repo (empty = git path) |
| `{component}.chart.name` | string | Chart name |
| `{component}.chart.version` | string | Chart version |
| `{component}.chart.nameOverride` | string | Override child chart name |
| `{component}.syncWave` | string | ArgoCD sync wave |

## Values Files Structure

ArgoCD Applications expect values at:

```
{valuesRepo.pathPrefix}/{namePrefix}-{component}/values.yaml
```

Example (`namePrefix: vm`, `pathPrefix: clusters/hub`):

```
clusters/hub/
├── vm-operator/values.yaml
├── vm-vmsingle/values.yaml
├── vm-vlsingle/values.yaml
├── vm-vmauth/values.yaml
└── vm-authentik-gateway/values.yaml
```

## Example

```yaml
namePrefix: vm
project: monitoring
destinationCluster: in-cluster

valuesRepo:
  url: https://github.com/my-org/gitops.git
  targetRevision: main
  pathPrefix: clusters/prod

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

authentikGateway:
  enabled: false
```
