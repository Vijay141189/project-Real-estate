variable "rgs" {}

variable "tags" {
  description = "Mandatory FinOps tags (Environment, Service, etc.)"
  type        = map(string)
  default     = {}
}
