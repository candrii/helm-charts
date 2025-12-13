# victoriametrics-vlsingle

VLSingle CRD for VictoriaLogs single-node log storage.

## Description

Deploys a `VLSingle` Custom Resource that the VictoriaMetrics Operator reconciles into a single-node VictoriaLogs instance for log storage.

## Requirements

- Kubernetes 1.21+
- VictoriaMetrics Operator installed

## CRD

Creates `VLSingle` (operator.victoriametrics.com/v1)

## Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `enabled` | bool | `true` | Enable/disable deployment |
| `name` | string | `monitoring` | Resource name |
| `namespace` | string | `monitoring` | Target namespace |
| `retentionPeriod` | string | `30` | Data retention period (days) |
| `storage.size` | string | `55Gi` | Storage volume size |
| `storage.storageClassName` | string | `""` | Storage class (empty = default) |
| `resources.requests.memory` | string | `500Mi` | Memory request |
| `resources.requests.cpu` | string | `1m` | CPU request |
| `resources.limits` | object | `{}` | Resource limits |

## Example

```yaml
enabled: true
name: logs
namespace: monitoring
retentionPeriod: "60"
storage:
  size: 200Gi
  storageClassName: fast-ssd
resources:
  requests:
    memory: 1Gi
    cpu: 250m
  limits:
    memory: 2Gi
```
