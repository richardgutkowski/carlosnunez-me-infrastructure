module "kubernetes-cluster" {
  source = "./modules/kubernetes-cluster"
  aws_region = "us-east-1"
  kubernetes_controller_instance_size = "${var.kubernetes_controller_instance_size}"
}
