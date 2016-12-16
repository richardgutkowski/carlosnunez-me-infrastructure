variable "coreos_ami_id" {
  description = "ID of the AWS AMI for CoreOS."
}

variable "coreos_number_of_instances" { 
  description = "Number of CoreOS instances to deploy."
  default = 1
}

variable "infra_subnet_id" {
  description = "Subnet to deploy infrastructure onto."
}

variable "coreos_instance_type" {
  description = "Instance type to use for CoreOS infrastructure."
  default = "t2.micro"
}
