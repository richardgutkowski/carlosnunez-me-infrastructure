variable "infra_subnet_id" {
  description = "Subnet to deploy infrastructure onto."
}

variable "aws_infra_tags" {
  description "Tags for all AWS infrastructure."
  default {
    "Owner" = "dev@carlosnunez.me"
    "Environment" = "Production"
  }
}
