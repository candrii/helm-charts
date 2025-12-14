# victoriametrics-authentik-gateway

Authentik SSO integration for VictoriaMetrics via Gateway API with VMAuth proxy.

## Description

Deploys SSO authentication for VictoriaMetrics using:
- **VMAuth** - VictoriaMetrics auth proxy (subchart from official helm charts)
- **Outpost Deployment** - Authentik proxy for forward authentication
- **Gateway API** - HTTPRoute for traffic routing

## Requirements

- Kubernetes 1.21+
- [Gateway API](https://gateway-api.sigs.k8s.io/) controller
- [Authentik](https://goauthentik.io/) instance

## Dependencies

| Chart | Version | Repository |
|-------|---------|------------|
| victoria-metrics-auth | 0.20.0 | https://victoriametrics.github.io/helm-charts/ |

## Resources Created

| Resource | API Group | Description |
|----------|-----------|-------------|
| Deployment | apps/v1 | VMAuth proxy (from subchart) |
| Deployment | apps/v1 | Authentik outpost proxy |
| Service | v1 | VMAuth service |
| Service | v1 | Outpost service |
| HTTPRoute | gateway.networking.k8s.io/v1 | Traffic routing |

## Configuration

### VMAuth (subchart)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `vmauth.enabled` | bool | `true` | Deploy VMAuth |
| `vmauth.config.unauthorized_user.url_prefix` | list | - | Backend URL(s) |
| `vmauth.service.servicePort` | int | `8427` | Service port |

See [victoria-metrics-auth chart](https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-metrics-auth) for full configuration options.

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
| `httpRoute.backendService.name` | string | - | Backend service (VMAuth) |
| `httpRoute.backendService.port` | int | - | Backend port |
| `httpRoute.forwardAuth.enabled` | bool | `true` | Enable forward auth |
| `httpRoute.forwardAuth.authPath` | string | `/outpost.goauthentik.io/auth/nginx` | Auth endpoint path |
| `httpRoute.forwardAuth.callbackPath` | string | `/outpost.goauthentik.io` | Callback path prefix |

### Supported Auth Paths

| Proxy | authPath |
|-------|----------|
| nginx | `/outpost.goauthentik.io/auth/nginx` |
| traefik | `/outpost.goauthentik.io/auth/traefik` |
| caddy | `/outpost.goauthentik.io/auth/caddy` |
| envoy | `/outpost.goauthentik.io/auth/envoy` |

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

vmauth:
  enabled: true
  config:
    unauthorized_user:
      url_prefix:
        - http://vmsingle-monitoring.monitoring.svc:8429
  service:
    servicePort: 8427

outpostDeployment:
  enabled: true
  name: vm-authentik-outpost
  authentik:
    url: https://auth.example.com
    tokenSecretName: authentik-outpost-token

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
    name: vmauth
    namespace: monitoring
    port: 8427
  forwardAuth:
    enabled: true
    authPath: /outpost.goauthentik.io/auth/nginx
    callbackPath: /outpost.goauthentik.io
```
