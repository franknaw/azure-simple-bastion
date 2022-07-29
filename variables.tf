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

variable "github_runner_token" {
  description = "The GitHub runner token."
  type        = string
  sensitive   = true
}

variable "github_org_name" {
  description = "The GitHub organization."
  type        = string
}

variable "github_runner_name" {
  description = "The GitHub runner name."
  type        = string
}

variable "runner_labels" {
  description = "list of labels to associate to the runner"
  type        = list(string)
}

variable "ubuntu_source_image_reference" {
  description = "The linux Ubuntu publisher image to use."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })

  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}