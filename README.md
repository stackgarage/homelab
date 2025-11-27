![GitHub](https://img.shields.io/github/v/release/stackgarage/homelab) ![Terragrunt Stack](https://github.com/stackgarage/homelab/actions/workflows/terragrunt-stack-env.yml/badge.svg) ![License](https://img.shields.io/github/license/stackgarage/homelab) ![Issues](https://img.shields.io/github/issues/stackgarage/homelab)

# Homelab

A Homelab Infrastructure-as-Code playground where I'm `uid=0`; I run the show: root access, full chaos. Powered by a K3s cluster, on Proxmox, hosting a variety of self-hosted services. (WIP)

## Design Rationale

The IaC is designed using the below K8s and Terragrunt logical design

### K8s

Order of resource deployment based on dependency and resource existence as a framework for the overall order of operations:

```
        ┌────────────────────┐
        │    Applications    │
        └────────┬───────────┘
                 │ depends on
        ┌────────▼───────────┐
        │      Platform      │
        └────────┬───────────┘
                 │ depends on
        ┌────────▼───────────┐
        │   Infrastructure   │
        └────────┬───────────┘
                 │ depends on
        ┌────────▼───────────┐
        │    Core Cluster    │
        └────────────────────┘
```

### Terragrunt 

The infrastructure code is organized around the following logical hierarchy, implemented using Terragrunt [stacks](https://terragrunt.gruntwork.io/docs/features/stacks/) and [units](https://terragrunt.gruntwork.io/docs/features/units/) primitives:

```
Environment > Stack > Units
```


| Environment | a collection of stacks representing the full environment (cluster + platform + infrastructure layers) |
| --- | --- |
| **Stack** | **a collection of units representing a middleware or core platform layer (e.g., `gha-arc`, `cert-manager`, etc)** |
| **Unit** | **a Terraform module representing a specific tool or resource (e.g., `cert-manager`, VM, etc)**


### Combining Both

Each layer in the K8s diagram is represented as a corresponding Terragrunt stack.[for example this one](https://github.com/stackgarage/homelab/tree/main/terraform/live/prod).

## Resource State (Terraform Backend)

Thanks to Terragrunt's `generate` blocks, state files are cleanly organized in S3 as:  `live/<env>/<stack>/.terragrunt-stack/<unit>` pretty much mirroring the repo's directory hierarchy.  

This makes clear separation across boundaries. It also prevents the sprawl of S3 objects across bucket's paths, and saved me from staring at the backend bucket thinking, *"what a mess."*

## Automation

- **Infrastructure**: GitHub Actions designed to handle deployments at both the Terragrunt stack and full-environment level, while supporting helper workflows and tools such as labelers, linters, and other code management and quality workflows.

- **Applications**: currently deployed via Helmfile; a bit clunky, but a handy tool. It will eventually be replaced by a GitOps tool to further simplify application deployments.
A homelab Infrastructure-as-Code playground where I'm `uid=0`, i.e., I run the show - root access, full chaos. (WIP)

![GitHub](https://img.shields.io/github/v/release/tinycloud-labs/infrastructure) ![Terragrunt Stack](https://github.com/tinycloud-labs/infrastructure/actions/workflows/terragrunt-stack-env.yml/badge.svg) ![Terragrunt Environment](https://github.com/tinycloud-labs/infrastructure/actions/workflows/terragrunt-deploy-env.yml/badge.svg) ![License](https://img.shields.io/github/license/tinycloud-labs/infrastructure) ![Issues](https://img.shields.io/github/issues/tinycloud-labs/infrastructure)
