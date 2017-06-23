module "kubernetes-cluster" {
  source = "./modules/kubernetes-cluster"
  aws_region = "${var.aws_region}"
  kubernetes_controller_instance_size = "${var.kubernetes_controller_instance_size}"
  kubernetes_controller_count = "${var.kubernetes_controller_count}"
}
