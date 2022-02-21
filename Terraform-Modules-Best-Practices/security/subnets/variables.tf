# Resource Group
variable "rg_name" {
  description = "The name of the resource group to deploy in."
}

# Subnet Vars
variable "name" {
  description = "The name of the subnet."
}
variable "vnet_name" {
  description = "The name of the VNET to create the subnet in."
}
variable "address_prefixes" {
  description = "The address prefix to use for the subnet."
}
variable "nsg_id" {
  description = "The ID of a network security group to associate to this subnet."
  default     = null
}

# TAGS
variable "created_on" {
    default     = ""
}

variable "tags" {
    description     = "Description of tags"
    type            = map

    default = {
        owner           = "Sean Cochrane"
        cost_center     = "I.T. Operations"
        environment     = "Production"
        project_name    = "Quick Starts"
        created_by      = "Tangent Solutions"
        approved_by     = "Sean Cochrane"
        sla             = "99.99"
        rto             = "< 4 hrs"
    }
}