variable "aws_region" {
  description = "The AWS region onto which this infrastructure will be deployed."
}

variable "kubernetes_controller_instance_size" {
  description = "The size for our Kubernetes controller."
  default = "t2.micro"
}

variable "kubernetes_controller_count" {
  description = "Number of Kubernetes controllers to deploy."
}

variable "ec2_key_name" {
  description = "The name to use for the EC2 keypair consumed by all EC2 instances"
}

variable "ec2_public_key" {
  description = "The public key to use for this keypair."
}
