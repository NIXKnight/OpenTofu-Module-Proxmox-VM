output "vm_ips" {
  description = "Map of VM names to their IP addresses"
  value = {
    for vm_key, vm in proxmox_vm_qemu.vms : vm.name => can(regex("^ip=dhcp", vm.ipconfig0)) ? "DHCP (assigned at runtime)" : regex("ip=([^/,]+)", vm.ipconfig0)[0]
  }
}
