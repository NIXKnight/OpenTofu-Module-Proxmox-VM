resource "proxmox_vm_qemu" "vms" {
  for_each = local.merged_vms

  # Basic VM configuration
  name        = each.value.name
  vmid        = each.value.vmid
  target_node = var.target_node

  # Conditionally use the template if provided
  clone_id   = each.value.template_vm_id != null && each.value.template_vm_id != "" ? each.value.template_vm_id : null
  full_clone = each.value.template_vm_id != null && each.value.template_vm_id != ""
  desc       = each.value.description

  # System configuration
  sockets = each.value.sockets
  cores   = each.value.cores
  memory  = each.value.memory
  onboot  = true

  # OS and boot configuration
  os_type = "cloud-init"
  qemu_os = "l26"
  boot    = each.value.cdrom_iso != "" ? "order=virtio0;ide3" : "order=virtio0"

  # QEMU agent configuration
  agent = 1

  # Cloud-init configuration
  ciuser       = each.value.admin_user
  sshkeys      = each.value.user_ssh_key
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

      # Conditional virtio1 disk
      dynamic "virtio1" {
        for_each = [for disk in each.value.additional_disks : disk if disk.id == "virtio1"]
        content {
          disk {
            storage = virtio1.value.storage
            size    = virtio1.value.size
          }
        }
      }

      # Conditional virtio2 disk
      dynamic "virtio2" {
        for_each = [for disk in each.value.additional_disks : disk if disk.id == "virtio2"]
        content {
          disk {
            storage = virtio2.value.storage
            size    = virtio2.value.size
          }
        }
      }

      # Conditional virtio3 disk
      dynamic "virtio3" {
        for_each = [for disk in each.value.additional_disks : disk if disk.id == "virtio3"]
        content {
          disk {
            storage = virtio3.value.storage
            size    = virtio3.value.size
          }
        }
      }

      dynamic "virtio4" {
        for_each = [for disk in each.value.additional_disks : disk if disk.id == "virtio4"]
        content {
          disk {
            storage = virtio4.value.storage
            size    = virtio4.value.size
          }
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

  # Conditionally attach a virtual TPM 2.0 device
  dynamic "tpm_state" {
    for_each = each.value.tpm_storage != null && each.value.tpm_storage != "" ? [1] : []
    content {
      storage = each.value.tpm_storage
      version = "v2.0"
    }
  }

  # Tags
  tags = each.value.tags
}
