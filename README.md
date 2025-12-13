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
| [argocd-victoriametrics-stack](charts/argocd-victoriametrics-stack/) | 0.0.2 | ArgoCD Application to deploy Victoria Metrics stack with operator |
| [victoriametrics-authentik-gateway](charts/victoriametrics-authentik-gateway/) | 0.0.1 | Authentik gateway for Victoria Metrics authentication |
| [victoriametrics-vlsingle](charts/victoriametrics-vlsingle/) | 0.0.1 | VLSingle CRD for Victoria Metrics Logs single instance deployment |
| [victoriametrics-vmauth](charts/victoriametrics-vmauth/) | 0.0.1 | VMAuth CRD for Victoria Metrics authentication proxy |
| [victoriametrics-vmsingle](charts/victoriametrics-vmsingle/) | 0.0.2 | VMSingle CRD for Victoria Metrics single instance deployment |

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
