variable "ec2_subnet_id" {
  description = "Subnet to deploy infrastructure into."
}

variable "ec2_tags" {
  description = "Tags to apply onto all EC2 infrastructure."
  type = "map"
}

variable "ec2_user_data" {
  description = "User data to apply onto all EC2 infrastructure."
}

variable "ec2_vpc_id" {
  description = "VPC to target."
}

variable "ec2_vpc_cidr_block" {
  description = "VPC CIDR block."
  type = "list"
}

variable "ec2_default_ssh_access_sg_id" {
  description = "ID corresponding to unmanaged default-ssh-access-policy"
}

variable "ec2_route53_rr_suffix" {
  description = "The Route53 resource record suffix to apply onto EC2 resources."
}

variable "ec2_key_name" {
  description = "The name of the access keypair to use for EC2 instances."
}
