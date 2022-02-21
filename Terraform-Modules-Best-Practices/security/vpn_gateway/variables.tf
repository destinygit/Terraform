variable "vwan_name" {
    description = "Add a name for the virtual wan"
}

variable "vhub_name" {
    description = "Add a name for the virutal hub"
}

variable "vpngw_name" {
    description = "Add a name for the vpn gateway"
}

variable "location" {
  description = "The region to deploy the resources in"
}

variable "rg_name" {
  description = "The name of the resource group to deploy in."
}

variable "address_prefix" {
    description = "Add the address prefix"
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