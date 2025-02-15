locals {
  default_vm = {
    # Required fields like name and vmid are not given defaults here because users should provide them.
    description  = ""
    memory       = 2048
    cores        = 1
    sockets      = 2
    disk_size    = 20
    disk_storage = "storage"
    ci_storage   = "local"
    networks = [
      {
        id     = 0
        bridge = "vmbr0"
        model  = "virtio"
      }
    ]
    ipconfig0 = "ip=dhcp"
    tags      = ""
  }

  # Merge each user-defined VM with the default settings + network settings.
  # Merging network settings was becoming a problem. Merging it explicitly here.
  merged_vms = {
    for key, vm in var.vms : key => merge(
      local.default_vm,
      vm,
      { networks = coalesce(vm.networks, local.default_vm.networks) }
    )
  }
}
