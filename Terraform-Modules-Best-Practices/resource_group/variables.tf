# Variables for Azure Resource Groups
# Resource group name formula: 'rg''environment''base_name'
variable "base_name" {
    description     = "Give the name for the Resource Group - See comment above for final format"
    default         = ""
}

variable "region" {
    description     = "The region where the resource should be deployed in"
    default         = "southafricanorth"
}

variable "environment" {
    description     = "The environment that the resource is deployed for"
    default         = ""
}

# variable "tags" {
#     description     = "Tags to add to the deployed resources"
#     default         = {}
# }

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

variable "deployedby" {
    description     = "Add the entity/process/person deploying the resource"
    default         = "Tangent Solutions"
}

variable "owner" {
    description     = "Give the name for the OWNER"
    default         = ""
}

variable "costcentre" {
    description     = "Give the name for the COST CENTRE"
    default         = ""
}

variable "business" {
    description     = "Add the name for the business"
    default         = "bb"
}

variable "shortlocation" {
    description     = "Short name for the location"
    default         = "zan"
}

variable "numberseq" {
    description     = "Number sequence for resource creation"
    default         = "001"
}