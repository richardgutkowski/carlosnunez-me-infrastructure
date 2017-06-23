variable "aws_region" {
  description = "The region onto which this cluster will be deployed."
}

variable "kubernetes_controller_instance_size" {
  description = "The size of your Kubernetes controller."
}

variable "kubernetes_controller_count" {
  description = "The number of controllers to provision. Must be greater than 3."
  default = 3
}
