variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "names" {
  description = "Names to be applied to resources"
  type        = map(string)
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
}

variable "subnet_id" {
  description = "Tags to be applied to resources"
  type        = string
}

variable "username" {
  description = "Tags to be applied to resources"
  type        = string
}

variable "public_key" {
  description = "Tags to be applied to resources"
  type        = string
}

variable "source_address_prefixes" {
  description = "Tags to be applied to resources"
  type        = map(string)
}

variable "destination_address_prefix" {
  description = "Tags to be applied to resources"
  type        = string
}
