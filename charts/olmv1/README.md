# OLMv1 (Operator Lifecycle Manager v1)

<!-- olmv1-upstream-commit: b871e7ec841a453a73438425309a4cc54660f0b8 -->

Helm chart for deploying [OLMv1](https://github.com/operator-framework/operator-controller) - the next generation Operator Lifecycle Manager for Kubernetes.

## Overview

This chart is synced from the upstream [operator-framework/operator-controller](https://github.com/operator-framework/operator-controller/tree/main/helm/olmv1) repository. It is automatically updated via the `sync-olmv1` GitHub Actions workflow.

## Source

- **Upstream Repository**: [operator-framework/operator-controller](https://github.com/operator-framework/operator-controller)
- **Upstream Chart Path**: `helm/olmv1`
- **Sync Workflow**: [.github/workflows/sync-olmv1.yml](../../.github/workflows/sync-olmv1.yml)

## How Updates Work

1. **Automatic Sync**: The `sync-olmv1` workflow runs daily and checks for new commits in the upstream `helm/olmv1` directory
2. **Commit Tracking**: The workflow tracks the latest commit SHA that modified the chart, not release versions
3. **Manual Trigger**: You can manually trigger the sync workflow with force option

### Manual Sync

To force a sync:

```bash
gh workflow run sync-olmv1.yml -f force=true
```

## Installation

### From OCI Registry

```bash
helm install olmv1 oci://ghcr.io/candrii/charts/olmv1 -n olmv1-system --create-namespace
```

### From Source

```bash
helm install olmv1 ./charts/olmv1 -n olmv1-system --create-namespace
```

## What is OLMv1?

OLMv1 is the next generation of the Operator Lifecycle Manager, redesigned to:

- Provide a simpler, more declarative API for managing operators
- Support multiple package formats (catalogs, bundles)
- Enable better dependency resolution
- Offer improved security and multi-tenancy support

### Key Components

- **operator-controller**: The main controller that manages operator installations
- **ClusterExtension**: CRD for declaring desired operator installations
- **ClusterCatalog**: CRD for declaring operator catalogs

## Requirements

- Kubernetes 1.27+
- Cert-manager (for webhook certificates)

## Configuration

See the upstream [values.yaml](https://github.com/operator-framework/operator-controller/blob/main/helm/olmv1/values.yaml) for all available configuration options.

## Versioning

- **Chart Version**: Incremented locally when syncing new upstream changes
- **Upstream Tracking**: Based on commit SHA of the `helm/olmv1` directory

## References

- [OLMv1 Documentation](https://operator-framework.github.io/operator-controller/)
- [OLMv1 GitHub Repository](https://github.com/operator-framework/operator-controller)
- [Migration from OLM v0](https://operator-framework.github.io/operator-controller/docs/getting-started/migration/)
- [ClusterExtension API Reference](https://operator-framework.github.io/operator-controller/docs/api-reference/)

## Chart Contents

> **Note**: This directory is a placeholder. The actual chart content will be populated by the `sync-olmv1` workflow when it first runs.

Once synced, this directory will contain:

```
olmv1/
├── Chart.yaml          # Chart metadata
├── values.yaml         # Default configuration values
├── README.md           # This documentation (preserved across syncs)
├── templates/          # Kubernetes manifest templates
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ...
└── base/               # Base configurations (if present)
```
