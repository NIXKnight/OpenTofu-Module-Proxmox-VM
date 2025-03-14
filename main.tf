resource "proxmox_vm_qemu" "vms" {
  for_each = local.merged_vms

  # Basic VM configuration
  name        = each.value.name
  vmid        = each.value.vmid
  target_node = var.target_node

  # Conditionally use the template if provided
  clone_id    = var.template_vm_id != "" ? var.template_vm_id : null
  full_clone  = var.template_vm_id != "" ? true : false
  desc        = each.value.description

  # System configuration
  sockets = each.value.sockets
  cores   = each.value.cores
  memory  = each.value.memory
  onboot  = true

  # OS and boot configuration
  os_type = "cloud-init"
  qemu_os = "l26"
  boot = each.value.cdrom_iso != "" ? "order=virtio0;ide3" : "order=virtio0"

  # QEMU agent configuration
  agent = 1

  # Cloud-init configuration
  ciuser       = var.admin_user
  sshkeys      = var.user_ssh_key
  searchdomain = var.searchdomain
  nameserver   = var.nameserver
  ipconfig0    = each.value.ipconfig0

  # Network configuration
  dynamic "network" {
    for_each = each.value.networks
    content {
      id     = network.value.id
      model  = network.value.model
      bridge = network.value.bridge
    }
  }

  # Serial console configuration
  serial {
    id   = 0
    type = "socket"
  }

  # Disk configuration
  disks {
    virtio {
      virtio0 {
        disk {
          storage = each.value.disk_storage
          size    = each.value.disk_size
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = each.value.ci_storage
        }
      }
      dynamic "ide3" {
        for_each = each.value.cdrom_iso != "" ? [each.value.cdrom_iso] : []
        content {
          cdrom {
            iso = ide3.value
          }
        }
      }
    }
  }

  # Tags
  tags = each.value.tags
}
