module "kubernetes-cluster" {
  source = "./modules/kubernetes-cluster"
  aws_region = "${var.aws_region}"
  kubernetes_controller_instance_size = "t2.micro"
}
