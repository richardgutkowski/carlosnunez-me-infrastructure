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
