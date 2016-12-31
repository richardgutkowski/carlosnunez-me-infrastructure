variable "global_infrastructure_tags" {
  description = "Tags to apply onto all infrastructure created by this deployment."
  default {}
}

variable "environment" {
  description = "Environment this infrastrucutre is targetting."
}
