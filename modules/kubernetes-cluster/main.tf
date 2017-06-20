resource "aws_instance" "kubernetes_controller" {
  aws_region = "us-east-1"
  ami = "${data.aws_ami.kubernetes_instances.id}"
  instance_type = "${var.kubernetes_controller_instance_size}"
}
