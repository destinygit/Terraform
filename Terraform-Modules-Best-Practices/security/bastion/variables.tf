variable "pubipname" {
    description = "Provide a name for the public IP"
}
variable "location" {
    description = "Location where resources are created"
}
variable "resource_group_name" {
    description = "Resource group name where resource will be created in"
}
variable "bastionname" {
    description = "Provide a name for the Bastion"
}
variable "azurerm_subnet_id" {
    description = "Provide the subnet_id"
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