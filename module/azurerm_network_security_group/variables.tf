variable "nsgs" {
  description = <<-EOT
    Map of NSGs. Har entry me:
      name, location, resource_group_name, subnet_id (null ho sakta hai agar direct associate nahi karna),
      rules = list of { name, priority, direction, access, protocol, source_port_range,
                         destination_port_range, source_address_prefix, destination_address_prefix }
  EOT
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_id           = optional(string)
    rules = map(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "subnet_association_keys" {
  description = "Static set of nsg keys jinke liye subnet association banani hai. Root module se pass hota hai (subnet_key ke basis par, jo tfvars se static known hai — subnet_id se nahi, jo apply ke baad hi pata chalta hai)."
  type        = set(string)
  default     = []
}
