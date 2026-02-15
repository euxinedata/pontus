# Pontus — Project Context

IaC repository for the Euxine Data Platform. Provisions k3s clusters on Hetzner Cloud using OpenTofu and cloud-init.

## Architecture

Three layers with separate Terraform state, applied in order:

1. **persistent** — Floating IP + volume. Created once, never destroyed. DNS points here.
2. **cluster** — Server VM running k3s control plane. Ephemeral — destroy/recreate freely.
3. **workers** — Worker VMs that join the k3s cluster. Ephemeral, scaled independently.

Each layer reads the previous layer's state via `terraform_remote_state`.

## Repository Structure

```
modules/hetzner/
  persistent/          Reusable module: floating IP + volume
  cluster/             Reusable module: server VM + attachments
  workers/             Reusable module: worker VMs + node cleanup
envs/dev/
  persistent/          Dev persistent layer
  cluster/             Dev cluster layer
    templates/         cloud-init.yaml.tftpl (server bootstrap)
  workers/             Dev workers layer
    templates/         cloud-init-worker.yaml.tftpl (worker join)
```

## Key Design Decisions

- **Persistent volume at `/mnt/data`**: k3s uses `--data-dir=/mnt/data/k3s` so cluster state (etcd, certificates, secrets) survives VM rebuilds.
- **k3s token via `random_password`**: Generated in cluster layer, passed to server cloud-init, output for workers to read via remote state.
- **Manifests in `runcmd`, not `write_files`**: cloud-init `write_files` runs before `runcmd`, but the volume mount happens in `runcmd`. Manifests written to `/mnt/data/k3s/server/manifests/` must come after the mount.
- **ArgoCD insecure mode**: `server.insecure: true` in `argocd-cmd-params-cm`. Traefik terminates TLS; ArgoCD serves plain HTTP on port 80. Avoids TLS-inside-TLS and redirect loops.
- **HTTP→HTTPS redirect**: Global Traefik entrypoint redirect via `HelmChartConfig` CRD, not per-ingress middleware.
- **cert-manager + Let's Encrypt**: HTTP-01 challenge via Traefik ingress class. `ClusterIssuer` named `letsencrypt-prod`.
- **Worker node cleanup**: `null_resource` with destroy-time `local-exec` provisioner drains and deletes k3s node before VM destruction.

## Current Dev Environment

- **Location**: nbg1 (Nuremberg)
- **Server type**: cpx42
- **Worker type**: cpx22 (cpx21 is blocked for new orders in nbg1)
- **Domains**: argocd.euxine.eu, app.euxine.eu (both point to floating IP)
- **Let's Encrypt email**: euxine.data@gmail.com
- **SSH key**: id_euxinedata@blackstar (pre-existing in Hetzner)

## Operational Commands

```bash
# Provision (first time)
cd envs/dev/persistent && tofu init && tofu apply
cd envs/dev/cluster && tofu init && tofu apply
cd envs/dev/workers && tofu init && tofu apply

# Wait for bootstrap
ssh root@<server-ip> "cloud-init status --wait"

# Destroy/recreate cluster (data persists on volume)
cd envs/dev/cluster && tofu destroy && tofu apply

# Scale workers
# Edit worker_count in envs/dev/workers/terraform.tfvars, then:
cd envs/dev/workers && tofu apply    # scale up
cd envs/dev/workers && tofu destroy  # remove all

# ArgoCD admin password
ssh root@<server-ip> "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
```

## Important Files

- `envs/dev/cluster/templates/cloud-init.yaml.tftpl` — Server bootstrap (k3s, ArgoCD, cert-manager, Helm, k9s, manifests)
- `envs/dev/workers/templates/cloud-init-worker.yaml.tftpl` — Worker join script
- `envs/dev/cluster/main.tf` — Server layer with `random_password` for k3s token
- `envs/dev/workers/main.tf` — Workers layer reading cluster state
- `modules/hetzner/workers/main.tf` — Worker module with destroy-time node cleanup

## Pitfalls

- When changing the k3s token (e.g., first time adding `--token`), existing bootstrap data on the volume conflicts. Must clear `/mnt/data/k3s/server/{db,tls,token,cred}` and restart k3s.
- Hetzner server type availability varies by location. If a type is blocked, try the newer generation (e.g., cpx22 instead of cpx21, cpx42 instead of cpx41).
- `terraform.tfvars` files are gitignored. Each layer needs its own copy (created from `terraform.tfvars.example`).
