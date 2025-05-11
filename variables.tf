variable "pm_api_url" {
  description = "The URL of the Proxmox API"
  type        = string
}

variable "target_node" {
  description = "Name of the Proxmox node to create the VMs on"
  type        = string
}

variable "searchdomain" {
  description = "Search domain for VMs"
  type        = string
}

variable "nameserver" {
  description = "DNS name server for VMs"
  type        = string
}

variable "vms" {
  description = "Map of VM configurations"
  type = map(object({
    name           = string
    vmid           = string
    template_vm_id = optional(string)
    admin_user     = optional(string)
    user_ssh_key   = optional(string)
    description    = optional(string)
    memory         = optional(number)
    cores          = optional(number)
    sockets        = optional(number)
    disk_size      = optional(number)
    disk_storage   = optional(string)
    additional_disks = optional(list(object({
      id      = string
      storage = string
      size    = number
    })), [])
    ci_storage = optional(string)
    networks = optional(list(object({
      id     = optional(number)
      bridge = optional(string)
      model  = optional(string)
    })))
    ipconfig0   = optional(string)
    tags        = optional(string)
    cdrom_iso   = optional(string)
    tpm_storage = optional(string)
  }))
}
