variable "aws_target_region" {
  description = "The AWS region onto which this infrastructure will be deployed."
}

variable "kubernetes_controller_instance_size" {
  description = "The size for our Kubernetes controller."
  default = "t2.micro"
}
