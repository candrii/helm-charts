# victoriametrics-vmauth

VMAuth CRD for VictoriaMetrics authentication proxy.

## Description

Deploys a `VMAuth` Custom Resource that the VictoriaMetrics Operator reconciles into an authentication proxy for routing and access control to VictoriaMetrics backends.

## Requirements

- Kubernetes 1.21+
- VictoriaMetrics Operator installed
- Ingress controller (nginx, etc.)

## CRD

Creates `VMAuth` (operator.victoriametrics.com/v1beta1)

## Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `enabled` | bool | `true` | Enable/disable deployment |
| `name` | string | `vmauth` | Resource name |
| `namespace` | string | `monitoring` | Target namespace |
| `selectAllByDefault` | bool | `true` | Allow all requests by default |
| `ingress.enabled` | bool | `true` | Enable ingress |
| `ingress.className` | string | `internal-nginx` | Ingress class name |
| `ingress.host` | string | `vm.hub.taxrise.lan` | Ingress hostname |
| `ingress.annotations` | object | `{}` | Ingress annotations |
| `urlMaps` | list | see values.yaml | Backend URL routing rules |
| `urlMaps[].srcPaths` | list | - | Source path patterns (regex) |
| `urlMaps[].urlPrefix` | list | - | Backend URL prefixes |
| `resources.requests` | object | `{memory: 64Mi, cpu: 1m}` | Resource requests |
| `resources.limits` | object | `{}` | Resource limits |
| `extraArgs` | object | `{}` | Extra VMAuth arguments |

## Example

```yaml
enabled: true
name: vmauth
namespace: monitoring
ingress:
  enabled: true
  className: nginx
  host: metrics.example.com
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
urlMaps:
  - srcPaths:
      - "/api/v1/.*"
      - "/vmui.*"
    urlPrefix:
      - "http://vmsingle-metrics:8429"
  - srcPaths:
      - "/select/logsql/.*"
    urlPrefix:
      - "http://vlsingle-logs:9428"
```
