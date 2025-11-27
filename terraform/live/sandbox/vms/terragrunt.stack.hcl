unit "cluster" {
  source = "${get_repo_root()}/terraform/catalog/units/vms"
  path   = "vms"

  values = {
    proxmox_node_name = "pve1"
    disk_name         = "sdd"
    cloud_image_info  = ["sdc", "debian-12-generic-amd64.qcow2.img"]
    description       = "Managed by Terragrunt."
    cluster = [
      {
        # Control plane
        name  = "cka-ctrl"
        size  = "small"
        count = 1
        macs  = ["3a:db:a4:a5:df:5c"]
      },
      {
        # Node group - small
        name  = "cka-w"
        size  = "small"
        count = 2
        macs = [
          "4e:6f:0a:96:3e:79",
          "66:09:0f:f7:54:06",
        ]
      },
    ]
  }
}
