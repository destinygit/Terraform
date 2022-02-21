variable "akv_name" {
    description = "Provide the name for the Azure Key Vault"
}
variable "location" {
    description = "Provide location for resource to be created in"
}
variable "resource_group_name" {
    description = "Provide the resource group name"
}
variable "tenant_id" {
    description = "Provide the tenant id"
}

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