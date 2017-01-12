variable "puppet_master_ami_id" {
  description = "ID of the AWS AMI for Puppet master."
}

variable "puppet_master_number_of_instances" { 
  description = "Number of Puppet master instances to deploy."
  default = 1
}

variable "puppet_master_instance_type" {
  description = "Instance type to use for Puppet master infrastructure."
  default = "t2.micro"
}

variable "puppet_master_tags" {
  description = "Tags to apply onto Puppet master instances."
  default {}
}

variable "puppet_master_user_data" {
  description = "User data to apply onto Puppet master instances."
}

variable "puppet_master_security_group_name" {
  description = "Name of the security group to use for Puppet master instances."
}
