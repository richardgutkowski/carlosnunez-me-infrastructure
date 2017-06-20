resource "aws_instance" "kubernetes_controller" {
  ami = "${data.aws_ami.kubernetes_instances.id}"
  instance_type = "${var.controller_instance_size}"
}
