data "template_file" "user_data" {
  template = "$${global_user_data}\n$${specific_user_data}"
  vars {
    global_user_data = "${var.ec2_user_data}"
    specific_user_data = "${var.coreos_user_data}"
  }
}

module "coreos_security_group" {
  source = "github.com/carlosonunez/tf_aws_sg/sg_coreos"
  security_group_name = "${var.coreos_security_group_name}"
  vpc_id = "${var.ec2_vpc_id}"
  source_cidr_blocks = "${var.ec2_vpc_cidr_block}"
  security_group_tags = "${var.ec2_tags}"
}

module "coreos_instances" {
  source = "github.com/carlosonunez/tf_aws_ec2_instance"
  ami_id = "${var.coreos_ami_id}"
  number_of_instances = "${var.coreos_number_of_instances}"

  // It would be nice to do a regex match on this instead of a simple length comparison, but
  // this was not available as of Terraform v0.8.
  subnet_id = "${length(var.coreos_subnet_id) > 0 ? var.coreos_subnet_id : var.ec2_subnet_id}"
  instance_type = "${var.coreos_instance_type}"
  instance_name = "${var.environment}-coreos"
  key_name = "${var.ec2_key_name}"
  user_data = "${data.template_file.user_data.rendered}"
  tags = "${merge(var.global_infrastructure_tags, var.ec2_tags, var.coreos_tags)}"
  security_group_ids = [
    "${module.coreos_security_group.security_group_id}",
    "${var.ec2_default_ssh_access_sg_id}"
  ]
  create_route53_cname_resource_records = true
  route53_hosted_zone_id = "${var.route53_hosted_zone_id}"
  route53_rr_suffix = "coreos.${var.ec2_route53_rr_suffix}"
}
