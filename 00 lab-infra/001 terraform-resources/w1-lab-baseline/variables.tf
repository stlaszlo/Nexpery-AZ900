variable "training_tenant_id" {
  description = "Microsoft Entra tenant ID containing the training subscription"
  type        = string
}

variable "training_subscription_id" {
  description = "Azure subscription ID used for the training environment"
  type        = string
}

variable "location" {
  description = "Primary Azure region for training resources"
  type        = string
  default     = "germanywestcentral"
}

variable "students" {
  description = "Student environments to create"
  type = map(object({
    display_name      = string
    vnet_cidr         = string
    workload_subnet   = string
    management_subnet = string
  }))
}