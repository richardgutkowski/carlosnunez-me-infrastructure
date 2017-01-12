variable "generic_ec2_number_of_instances" { 
  description = "Number of generic EC2 instances to deploy."
  default = 1
}

variable "generic_ec2_route53_rr_name" {
  description = "The name of the Route53 CNAME record to create, e.g. web, database, devbox."
}

variable "generic_ec2_instance_type" {
  description = "Instance type to use for generic EC2 infrastructure."
  default = "t2.micro"
}

variable "generic_ec2_tags" {
  description = "Tags to apply onto generic EC2 instances."
  type = "map"
}

variable "generic_ec2_user_data" {
  description = "User data to apply onto generic EC2 instances."
  default = ""
}
