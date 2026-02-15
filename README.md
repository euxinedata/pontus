# Pontus

Infrastructure-as-code for the Euxine Data Platform. Provisions a k3s cluster on Hetzner Cloud with ArgoCD, cert-manager, Helm, and TLS via Let's Encrypt.

## Architecture

The infrastructure is split into three layers with separate state:

- **persistent/** — Floating IP and volume. Created once, never torn down. DNS points to the floating IP.
- **cluster/** — Ephemeral server VM with k3s control plane. Can be destroyed and recreated freely. Reads persistent state to attach the floating IP and volume.
- **workers/** — Ephemeral worker VMs that join the k3s cluster. Can be scaled independently without touching the server.

k3s stores its data on the persistent volume (`/mnt/data/k3s`), so cluster state (certificates, secrets, workloads) survives VM rebuilds.

## Prerequisites

- [OpenTofu](https://opentofu.org/) >= 1.6
- A Hetzner Cloud account with an API token
- An SSH key uploaded to Hetzner Cloud
- DNS records pointing to the floating IP (created in the persistent step)

## Initial Setup (from scratch)

### 1. Create the persistent layer

```bash
cd envs/dev/persistent
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your values:

```
hcloud_token = "<your-api-token>"
name_prefix  = "pontus-dev"
location     = "nbg1"
volume_size  = 50
```

Then provision:

```bash
tofu init
tofu apply
```

Note the `floating_ip_address` from the output — point your DNS records to it:

- `argocd.example.com` -> floating IP
- `app.example.com` -> floating IP

### 2. Create the cluster

```bash
cd envs/dev/cluster
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:

```
hcloud_token      = "<your-api-token>"
ssh_key_name      = "<name-of-your-hetzner-ssh-key>"
server_name       = "pontus-dev-01"
server_type       = "cpx42"
location          = "nbg1"
letsencrypt_email = "you@example.com"
argocd_domain     = "argocd.example.com"
```

Then provision:

```bash
tofu init
tofu apply
```

### 3. Wait for bootstrap to complete

The VM uses cloud-init to install k3s, ArgoCD, cert-manager, Helm, and k9s. Wait for it to finish:

```bash
ssh root@<server-ip> "cloud-init status --wait"
```

This blocks until setup is done, then prints `status: done`.

### 4. Verify

```bash
ssh root@<server-ip>
kubectl get nodes          # should show Ready
kubectl get pods -n argocd # 7 pods Running
kubectl get pods -n cert-manager # 3 pods Running
kubectl get clusterissuer  # letsencrypt-prod Ready
```

ArgoCD is available at `https://argocd.example.com`. Get the admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d && echo
```

## Worker Nodes

Workers are managed in a separate state and can be added or removed while the cluster is running.

### First-time setup

```bash
cd envs/dev/workers
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:

```
hcloud_token = "<your-api-token>"
ssh_key_name = "<name-of-your-hetzner-ssh-key>"
worker_count = 1
worker_type  = "cpx22"
location     = "nbg1"
```

Then provision:

```bash
tofu init
tofu apply
```

Wait for workers to join:

```bash
ssh root@<worker-ip> "cloud-init status --wait"
```

Verify on the server:

```bash
ssh root@<server-ip> "kubectl get nodes"
```

### Adding more workers

Increase `worker_count` in `envs/dev/workers/terraform.tfvars` and apply:

```bash
cd envs/dev/workers
tofu apply
```

### Removing all workers

```bash
cd envs/dev/workers
tofu destroy
```

### Scaling down

Decrease `worker_count` and apply. Tofu will remove workers from the highest index first.

## Shutting Down the Cluster

Destroy only the VM — the floating IP, volume, and all k3s data are preserved:

```bash
cd envs/dev/cluster
tofu destroy
```

## Starting the Cluster Back Up

Recreate the VM — it reattaches to the persistent floating IP and volume:

```bash
cd envs/dev/cluster
tofu apply
```

Wait for cloud-init to finish:

```bash
ssh root@<server-ip> "cloud-init status --wait"
```

Once done, the cluster is fully operational with all previous state intact.

## Changing VM Size

Edit `server_type` in `envs/dev/cluster/terraform.tfvars` (e.g., `cpx21`, `cpx42`, `cpx51`), then destroy and recreate:

```bash
cd envs/dev/cluster
tofu destroy
tofu apply
ssh root@<server-ip> "cloud-init status --wait"
```

## Repository Structure

```
modules/hetzner/
  persistent/     Reusable module: floating IP + volume
  cluster/        Reusable module: server VM + attachments
  workers/        Reusable module: worker VMs
envs/dev/
  persistent/     Dev persistent layer (state kept)
  cluster/        Dev cluster layer (ephemeral)
    templates/    cloud-init template
  workers/        Dev workers layer (ephemeral)
    templates/    worker cloud-init template
```
