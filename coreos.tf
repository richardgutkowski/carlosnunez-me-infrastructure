module "coreos-infra-east" {
  source = "github.com/terraform-community-modules/tf_aws_ec2_instance"
  ami_id = "${var.coreos_ami_id}"
  number_of_instances = "${var.number_of_instances}"
  subnet_id = "${var.infra_subnet_id}"
  instance_type = "${var.coreos_instance_type}"
  tags = "${merge(var.infra_tags, var.ec2_tags, var.coreos_tags)}"
}
