provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_instance" "kubernetes_controller" {
  ami = "${data.aws_ami.kubernetes_instances.id}"
  instance_type = "${var.kubernetes_controller_instance_size}"
  count = "${var.kubernetes_controller_count}"
}
