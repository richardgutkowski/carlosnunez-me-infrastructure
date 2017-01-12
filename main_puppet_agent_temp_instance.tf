module "puppet_agent_test_instance" {
  source = "github.com/carlosonunez/terraform_modules/aws/ec2/instances/general"
  ami_id = "${data.aws_ami.ubuntu_latest.id}"
  number_of_instances = "${var.generic_ec2_number_of_instances}"

  // It would be nice to do a regex match on this instead of a simple length comparison, but
  // this was not available as of Terraform v0.8.
  subnet_id = "${var.ec2_subnet_id}"
  instance_type = "${var.generic_ec2_instance_type}"
  instance_name = "${var.environment}-puppet_agent_test_instance"
  key_name = "${var.ec2_key_name}"
  user_data = "${var.puppet_master_user_data}"
  tags = "${merge(var.global_infrastructure_tags, var.ec2_tags, var.generic_ec2_tags)}"
  security_group_ids = [
    "${var.ec2_default_ssh_access_sg_id}"
  ]
  create_route53_cname_resource_records = true
  route53_hosted_zone_id = "${var.route53_hosted_zone_id}"
  route53_rr_suffix = "${var.generic_ec2_route53_rr_name}.${var.ec2_route53_rr_suffix}"
}
