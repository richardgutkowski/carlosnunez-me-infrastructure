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

variable "aws_access_key_id" {
  description = "AWS access key."
}

variable "aws_secret_access_key" {
  description = "AWS secret key."
}

variable "aws_region" {
  description = "AWS region to target."
}
