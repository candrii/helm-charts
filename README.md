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

| Chart | Description |
|-------|-------------|
| [victoriametrics-vmsingle](charts/victoriametrics-vmsingle/) | VMSingle CRD for metrics storage |
| [victoriametrics-vlsingle](charts/victoriametrics-vlsingle/) | VLSingle CRD for logs storage |
| [victoriametrics-vmauth](charts/victoriametrics-vmauth/) | VMAuth CRD for authentication proxy |
| [argocd-victoriametrics-stack](charts/argocd-victoriametrics-stack/) | ArgoCD meta-chart for full stack |
| [victoriametrics-authentik-gateway](charts/victoriametrics-authentik-gateway/) | SSO integration with Authentik |

---

Modular Helm charts for deploying VictoriaMetrics observability stack on Kubernetes using the operator pattern.

## Prerequisites

### Required

- Kubernetes 1.21+
- [VictoriaMetrics Operator](https://docs.victoriametrics.com/operator/) - Manages VMSingle, VLSingle, VMAuth CRDs

### Optional (depending on components used)

- [ArgoCD](https://argo-cd.readthedocs.io/) - For `argocd-victoriametrics-stack`
- [Crossplane](https://crossplane.io/) with Authentik Provider - For `victoriametrics-authentik-gateway`
- [Gateway API](https://gateway-api.sigs.k8s.io/) controller (Envoy Gateway, etc.) - For `victoriametrics-authentik-gateway`
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

### Metrics + Logs + Auth Proxy

```yaml
# vm-vmauth/values.yaml
name: vmauth
namespace: monitoring
ingress:
  className: nginx
  host: metrics.example.com
urlMaps:
  - srcPaths: ["/.*"]
    urlPrefix: ["http://vmsingle-metrics:8429"]
```

### With SSO (Authentik)

```yaml
# vm-authentik-gateway/values.yaml
crossplane:
  providerConfigRef: authentik
  application:
    name: victoriametrics
    slug: victoriametrics
  provider:
    externalHost: https://metrics.example.com
    mode: forward_single
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
