variable "security_groups" {
  description = "Should be true to adopt and manage default security group"
  type        = bool
}
variable "sg_ingresss" {
  description = "List of maps of ingress rules to set on the default security group"
  type        = list(map(string))
  default     = []
}
variable "sg_egresss" {
  description = "List of maps of egress rules to set on the default security group"
  type        = list(map(string))
  default     = []
}
variable "sg_name" {
  description = "Name to be used on the default security group"
  type        = string
}

variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = null
}