# victoriametrics-authentik-gateway

Authentik SSO integration for VictoriaMetrics via Crossplane CRDs and Gateway API.

## Description

Deploys SSO authentication for VictoriaMetrics using:
- **Crossplane CRDs** - Declaratively manage Authentik resources
- **Outpost Deployment** - Authentik proxy for forward authentication
- **Gateway API** - HTTPRoute with SecurityPolicy for auth

## Requirements

- Kubernetes 1.21+
- [Crossplane](https://crossplane.io/) with Authentik Provider
- [Gateway API](https://gateway-api.sigs.k8s.io/) controller (Envoy Gateway)
- [Authentik](https://goauthentik.io/) instance

## Resources Created

### Crossplane (Authentik)

| Resource | API Group | Description |
|----------|-----------|-------------|
| Application | application.authentik.crossplane.io/v1alpha1 | App registration |
| ProxyProvider | provider.authentik.crossplane.io/v1alpha1 | Forward auth provider |
| Outpost | outpost.authentik.crossplane.io/v1alpha1 | Outpost registration |

### Kubernetes

| Resource | API Group | Description |
|----------|-----------|-------------|
| Deployment | apps/v1 | Authentik outpost proxy |
| Service | v1 | Outpost service |
| HTTPRoute | gateway.networking.k8s.io/v1 | Traffic routing |
| SecurityPolicy | gateway.envoyproxy.io/v1alpha1 | Forward auth filter |

## Configuration

### Crossplane

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `crossplane.providerConfigRef` | string | `authentik` | Provider config name |
| `crossplane.application.enabled` | bool | `true` | Create Application |
| `crossplane.application.name` | string | `victoriametrics` | App name |
| `crossplane.application.slug` | string | `victoriametrics` | App slug |
| `crossplane.provider.enabled` | bool | `true` | Create ProxyProvider |
| `crossplane.provider.name` | string | `victoriametrics-proxy` | Provider name |
| `crossplane.provider.externalHost` | string | - | External URL |
| `crossplane.provider.mode` | string | `forward_single` | Proxy mode |
| `crossplane.outpost.enabled` | bool | `true` | Create Outpost |
| `crossplane.outpost.name` | string | `victoriametrics-outpost` | Outpost name |

### Outpost Deployment

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `outpostDeployment.enabled` | bool | `true` | Deploy outpost |
| `outpostDeployment.name` | string | `vm-authentik-outpost` | Deployment name |
| `outpostDeployment.replicas` | int | `1` | Replica count |
| `outpostDeployment.image.repository` | string | `ghcr.io/goauthentik/proxy` | Image |
| `outpostDeployment.image.tag` | string | `2024.10.4` | Image tag |
| `outpostDeployment.authentik.url` | string | - | Authentik URL |
| `outpostDeployment.authentik.tokenSecretName` | string | `authentik-outpost-token` | Token secret |

### Gateway HTTPRoute

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `httpRoute.enabled` | bool | `true` | Create HTTPRoute |
| `httpRoute.name` | string | `vm-auth-route` | Route name |
| `httpRoute.parentRefs` | list | - | Gateway references |
| `httpRoute.hostnames` | list | - | Hostnames to match |
| `httpRoute.backendService.name` | string | - | Backend service |
| `httpRoute.backendService.port` | int | - | Backend port |
| `httpRoute.authFilter.enabled` | bool | `true` | Enable forward auth |

## Prerequisites

Create the outpost token secret:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: authentik-outpost-token
  namespace: monitoring
type: Opaque
stringData:
  token: <token-from-authentik>
```

## Example

```yaml
enabled: true
namespace: monitoring

crossplane:
  providerConfigRef: authentik
  application:
    name: victoriametrics
    slug: victoriametrics
  provider:
    name: victoriametrics-proxy
    externalHost: https://metrics.example.com
    mode: forward_single
    authorizationFlow: default-provider-authorization-implicit-consent
  outpost:
    name: victoriametrics-outpost
    type: proxy

outpostDeployment:
  enabled: true
  name: vm-authentik-outpost
  authentik:
    url: https://auth.example.com
    tokenSecretName: authentik-outpost-token
  resources:
    requests:
      memory: 64Mi
      cpu: 10m

httpRoute:
  enabled: true
  name: vm-auth-route
  parentRefs:
    - name: main-gateway
      namespace: gateway-system
      sectionName: https
  hostnames:
    - metrics.example.com
  backendService:
    name: vmauth-monitoring
    namespace: monitoring
    port: 8427
```
