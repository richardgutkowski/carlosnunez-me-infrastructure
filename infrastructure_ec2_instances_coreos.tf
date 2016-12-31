data "template_file" "user_data" {
  template = "$${global_user_data}\n$${specific_user_data}"
  vars {
    global_user_data = "${var.ec2_user_data}"
    specific_user_data = "${var.coreos_user_data}"
  }
}

module "infrastructure-ec2-instances-coreos" {
  source = "github.com/carlosonunez/tf_aws_ec2_instance"
  ami_id = "${var.coreos_ami_id}"
  number_of_instances = "${var.coreos_number_of_instances}"

  // It would be nice to do a regex match on this instead of a simple length comparison, but
  // this was not available as of Terraform v0.8.
  subnet_id = "${length(var.coreos_subnet_id) > 0 ? var.coreos_subnet_id : var.ec2_subnet_id}"
  instance_type = "${var.coreos_instance_type}"
  instance_name = "${var.environment}-coreos"
  user_data = "${data.template_file.user_data.rendered}"
  tags = "${merge(var.global_infrastructure_tags, var.ec2_tags, var.coreos_tags)}"
}
