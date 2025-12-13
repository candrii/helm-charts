# victoriametrics-vmsingle

VMSingle CRD for VictoriaMetrics single-node metrics storage.

## Description

Deploys a `VMSingle` Custom Resource that the VictoriaMetrics Operator reconciles into a single-node VictoriaMetrics instance for metrics storage.

## Requirements

- Kubernetes 1.21+
- VictoriaMetrics Operator installed

## CRD

Creates `VMSingle` (operator.victoriametrics.com/v1beta1)

## Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `enabled` | bool | `true` | Enable/disable deployment |
| `name` | string | `monitoring` | Resource name |
| `namespace` | string | `monitoring` | Target namespace |
| `retentionPeriod` | string | `21d` | Data retention period |
| `replicaCount` | int | `1` | Number of replicas |
| `storage.size` | string | `30Gi` | Storage volume size |
| `storage.accessModes` | list | `[ReadWriteOnce]` | PVC access modes |
| `storage.storageClassName` | string | `""` | Storage class (empty = default) |
| `resources.requests.memory` | string | `500Mi` | Memory request |
| `resources.requests.cpu` | string | `1m` | CPU request |
| `resources.limits` | object | `{}` | Resource limits |
| `extraArgs` | object | see values.yaml | Extra VMSingle arguments |

## Example

```yaml
enabled: true
name: metrics
namespace: monitoring
retentionPeriod: "30d"
storage:
  size: 100Gi
  storageClassName: fast-ssd
resources:
  requests:
    memory: 2Gi
    cpu: 500m
  limits:
    memory: 4Gi
extraArgs:
  search.maxUniqueTimeseries: "10000000"
  search.maxQueryDuration: "300s"
```
