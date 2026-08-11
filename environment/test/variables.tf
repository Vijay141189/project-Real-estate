variable "rgs" {}
variable "storage_accounts" {}
variable "vnets" {}
variable "subnets" {}
variable "public_ips" {}
variable "vms" {}
variable "key_vaults" {}
variable "nsgs" {}

variable "tags" {
  description = "Mandatory FinOps/governance tags applied to every resource"
  type        = map(string)
  default     = {}
}
