module "kubernetes-cluster" {
  aws_region = "${var.aws_region}"
  source = "./modules/kubernetes-cluster"
  kubernetes_controller_instance_size = "${var.kubernetes_controller_instance_size}"
}
