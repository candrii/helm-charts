# CAndrii Helm Charts

## Add Helm Repository

**GitHub Pages:**
```bash
helm repo add candrii https://candrii.github.io/helm-charts
helm repo update
```

**OCI (GitHub Container Registry) - Helm v4:**
```bash
helm registry login ghcr.io
helm pull oci://ghcr.io/candrii/charts/victoriametrics-vmsingle --version 0.1.0
```

## Charts

| Chart | Version | Description |
|-------|---------|-------------|
| [argocd-victoriametrics-stack](charts/argocd-victoriametrics-stack/) | 1.2.0 | ArgoCD Application to deploy Victoria Metrics stack with operator |
| [grafana-operator-grafana](charts/grafana-operator-grafana/) | 0.2.1 | Grafana CRD for Grafana Operator - deploys Grafana instance via operator |
| [olmv1](charts/olmv1/) | 0.1.1 | A Helm chart for OLMv1 |
| [victoriametrics-vlsingle](charts/victoriametrics-vlsingle/) | 0.0.3 | VLSingle CRD for Victoria Logs single instance deployment |
| [victoriametrics-vmagent](charts/victoriametrics-vmagent/) | 0.0.2 | VMAgent CRD for Victoria Metrics metrics collection agent |
| [victoriametrics-vmalert](charts/victoriametrics-vmalert/) | 0.0.2 | VMAlert for VictoriaMetrics/VictoriaLogs alerting and recording rules |
| [victoriametrics-vmsingle](charts/victoriametrics-vmsingle/) | 0.0.4 | VMSingle CRD for Victoria Metrics single instance deployment |

---

Modular Helm charts for deploying VictoriaMetrics observability stack on Kubernetes using the operator pattern.

## Prerequisites

### Required

- Kubernetes 1.21+
- [VictoriaMetrics Operator](https://docs.victoriametrics.com/operator/) - Manages VMSingle, VLSingle CRDs
- [Grafana Operator](https://grafana.github.io/grafana-operator/) - Manages Grafana CRDs

### Optional (depending on components used)

- [ArgoCD](https://argo-cd.readthedocs.io/) - For `argocd-victoriametrics-stack`
- [Authentik](https://goauthentik.io/) - For SSO integration via `authentik-remote-cluster`

## Configuration Examples

### Minimal Metrics Stack

```yaml
# vm-vmsingle/values.yaml
name: metrics
namespace: monitoring
retentionPeriod: "30d"
storage:
  size: 100Gi
```

### With VMAuth Proxy

```yaml
# argocd-victoriametrics-stack values
vmauth:
  enabled: true
  values:
    config:
      unauthorized_user:
        url_prefix:
          - http://vmsingle-metrics.monitoring.svc:8429
```

### With Authentik Remote Cluster

```yaml
# argocd-victoriametrics-stack values
authentikRemoteCluster:
  enabled: true
  namespace: authentik-remote
```

## License

MIT
