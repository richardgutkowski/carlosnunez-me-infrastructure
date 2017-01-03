variable "coreos_ami_id" {
  description = "ID of the AWS AMI for CoreOS."
}

variable "coreos_number_of_instances" { 
  description = "Number of CoreOS instances to deploy."
  default = 1
}

variable "coreos_instance_type" {
  description = "Instance type to use for CoreOS infrastructure."
  default = "t2.micro"
}

variable "coreos_subnet_id" {
  description = "Subnet to place CoreOS containers into."
}

variable "coreos_tags" {
  description = "Tags to apply onto CoreOS instances."
  default {}
}

variable "coreos_user_data" {
  description = "User data to apply onto CoreOS instances."
}

variable "coreos_security_group_name" {
  description = "Name of the security group to use for CoreOS instances."
}

variable "coreos_provisioning_commands" {
  description = "Provisioning commands for CoreOS instances."
  default = []
}
