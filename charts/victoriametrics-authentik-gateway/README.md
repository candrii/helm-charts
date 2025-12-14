# victoriametrics-authentik-gateway

Authentik SSO integration for VictoriaMetrics via Gateway API.

## Description

Deploys SSO authentication for VictoriaMetrics using:
- **Outpost Deployment** - Authentik proxy for forward authentication
- **Gateway API** - HTTPRoute with SecurityPolicy for auth

## Requirements

- Kubernetes 1.21+
- [Gateway API](https://gateway-api.sigs.k8s.io/) controller (Envoy Gateway)
- [Authentik](https://goauthentik.io/) instance

## Resources Created

| Resource | API Group | Description |
|----------|-----------|-------------|
| Deployment | apps/v1 | Authentik outpost proxy |
| Service | v1 | Outpost service |
| HTTPRoute | gateway.networking.k8s.io/v1 | Traffic routing |
| SecurityPolicy | gateway.envoyproxy.io/v1alpha1 | Forward auth filter |

## Configuration

### Outpost Deployment

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `outpostDeployment.enabled` | bool | `true` | Deploy outpost |
| `outpostDeployment.name` | string | `vm-authentik-outpost` | Deployment name |
| `outpostDeployment.replicas` | int | `1` | Replica count |
| `outpostDeployment.image.repository` | string | `ghcr.io/goauthentik/proxy` | Image |
| `outpostDeployment.image.tag` | string | `2025.10.2` | Image tag |
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
