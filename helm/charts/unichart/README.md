# Stateful Apps Helm Chart

A universal chart for many use cases. Supports both stateful and stateless applications. It can provision deployment, statefulset + headless service for DB, storage, and ingress.

| Component | Type         | Purpose                                |
|-----------|--------------|----------------------------------------|
| `app`     | Deployment   | The core application logic            |
| `database`      | StatefulSet  | Database                              |
| `Service` | ClusterIP    | Internal service for app access        |
| `Ingress` | Ingress Resource      | External app access (optional)         |
| `Headless Service` | ClusterIP = None | For DB DNS resolution        |
| `persistence` | PV and PVC | NFS-backend Storage        |
