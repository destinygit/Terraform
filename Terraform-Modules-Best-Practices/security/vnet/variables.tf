# Global Variables
variable "location" {
  description = "The region to deploy the resources in."
}
variable "base_name" {
  description = "The base name to use for all resources."
  default     = ""
}

# Resource Group
variable "rg_name" {
  description = "The name of the resource group to deploy in."
}

# VNET Vars
variable "address_spaces" {
  description = "An array of address spaces to use in this VNET instance."
  default     = null
  type        = list(string)
}
variable "dns_servers" {
  description = "An array of DNS servers to use in the VNET."
  default     = null
  type        = list(string)
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