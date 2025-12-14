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
| [argocd-victoriametrics-stack](charts/argocd-victoriametrics-stack/) | 0.0.3 | ArgoCD Application to deploy Victoria Metrics stack with operator |
| [victoriametrics-authentik-gateway](charts/victoriametrics-authentik-gateway/) | 0.0.3 | VMAuth + Authentik outpost + Gateway HTTPRoute for SSO |
| [victoriametrics-vlsingle](charts/victoriametrics-vlsingle/) | 0.0.1 | VLSingle CRD for Victoria Logs single instance deployment |
| [victoriametrics-vmsingle](charts/victoriametrics-vmsingle/) | 0.0.2 | VMSingle CRD for Victoria Metrics single instance deployment |

---

Modular Helm charts for deploying VictoriaMetrics observability stack on Kubernetes using the operator pattern.

## Prerequisites

### Required

- Kubernetes 1.21+
- [VictoriaMetrics Operator](https://docs.victoriametrics.com/operator/) - Manages VMSingle, VLSingle CRDs

### Optional (depending on components used)

- [ArgoCD](https://argo-cd.readthedocs.io/) - For `argocd-victoriametrics-stack`
- [Gateway API](https://gateway-api.sigs.k8s.io/) controller - For `victoriametrics-authentik-gateway`
- [Authentik](https://goauthentik.io/) instance - For SSO

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

### With SSO (Authentik + VMAuth)

```yaml
# vm-authentik-gateway/values.yaml
vmauth:
  enabled: true
  config:
    unauthorized_user:
      url_prefix:
        - http://vmsingle-metrics.monitoring.svc:8429
outpostDeployment:
  authentik:
    url: https://auth.example.com
    tokenSecretName: authentik-outpost-token
httpRoute:
  hostnames:
    - metrics.example.com
  parentRefs:
    - name: main-gateway
      namespace: gateway-system
```

## License

MIT
