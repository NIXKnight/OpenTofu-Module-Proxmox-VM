variable "pm_api_url" {
  description = "The URL of the Proxmox API"
  type        = string
}

variable "target_node" {
  description = "Name of the Proxmox node to create the VMs on"
  type        = string
}

variable "template_vm_id" {
  description = "Name of the template to clone from"
  type        = string
  default     = ""
}

variable "user_ssh_key" {
  type        = string
  description = "Public SSH key for VM access"
  default     = ""
}

variable "admin_user" {
  type        = string
  description = "Admin username for VMs"
  default     = ""
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
    name         = string
    vmid         = string
    description  = optional(string)
    memory       = optional(number)
    cores        = optional(number)
    sockets      = optional(number)
    disk_size    = optional(number)
    disk_storage = optional(string)
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
    ipconfig0 = optional(string)
    tags      = optional(string)
    cdrom_iso = optional(string)
  }))
}
