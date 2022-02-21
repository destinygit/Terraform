variable "acr_name" {
    description = "Provides a name for the ACR"
}
variable "rg_name" {
  description = "The name of the resource group to deploy in."
}

variable "location" {
    description     = "The region where the resource should be deployed in"
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