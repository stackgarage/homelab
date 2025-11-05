# NFS Persistent Volume Chart (Static & Dynamic Provisioning)

This Helm chart provisions a `PersistentVolumeClaim`. It supports both dynamic and static volume provisioning.

>[!Note]
> In static provisioning mode, the chart explicitly binds the PVC to the matching PV using `spec.volumeName`. This avoids relying on Kubernetes to auto-select a PV and ensures the PVC is always backed by the intended NFS share. This is useful when precise control over NFS path mapping is required.

### Features

- Supports dynamic provisioning via a `StorageClass`. This assumes the cluster already has an NFS CSI driver is pre-configured. See [CSI driver deployment example](https://github.com/tinycloud-labs/infrastructure/tree/main/terraform/k3s-main/csi-driver-nfs).
- Supports static NFS provisioning by creating a corresponding `PersistentVolume`.
- Optional metadata: labels, annotations, and namespace override.

### Configuration

| Parameter                        | Description                                               | Example                   |
|----------------------------------|-----------------------------------------------------------|---------------------------|
| `persistence.name`               | Name of the PVC (and PV for static provisioning)          | `my-pvc`                  |
| `persistence.size`               | Requested storage size                                    | `100Mi`                   |
| `persistence.accessMode`         | Access mode (`ReadWriteOnce`, `ReadWriteMany`, etc.)      | `ReadWriteMany`           |
| `persistence.reclaimPolicy`      | Reclaim policy for the PV (used only in static mode)      | `Retain`                  |
| `persistence.storageClassName`   | StorageClass to use. If empty, static provisioning is assumed | `nfs-client` or `""`   |
| `persistence.nfs.server`         | NFS server address (required in static mode)              | `10.0.0.5`                |
| `persistence.nfs.path`           | NFS mount path (required in static mode)               | `/exports/data`           |

### Provisioning Modes

#### Dynamic Provisioning

To enable dynamic provisioning, set a `storageClassName` and ignore the `nfs` part:

```yaml
persistence:
  ...
  storageClassName: nfs-client
  ...
```

#### Static NFS Provisioning

To enable static provisioning (i.e., PV + PVC), set the `nfs` config and ignore/pass an empty string to `storageClassName`:

```yaml
persistence:
  ...
  storageClassName: ""
  nfs:
    server: 10.0.0.5
    path: /path/on/NFS/server/foo/bar
  ...
```
