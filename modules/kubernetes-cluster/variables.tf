variable "aws_region" {
  description = "The region onto which this cluster will be deployed."
  default = "us-east-1"
}

variable "kubernetes_controller_instance_size" {
  description = "The size of your Kubernetes controller."
}
