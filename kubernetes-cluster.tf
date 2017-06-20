module "kubernetes-cluster" {
  source = "./modules/kubernetes-cluster"
  kaws_region = "${var.aws_region}"
  kubernetes_controller_instance_size = "${var.kubernetes_controller_instance_size}"
}
