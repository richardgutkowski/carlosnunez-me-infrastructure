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
