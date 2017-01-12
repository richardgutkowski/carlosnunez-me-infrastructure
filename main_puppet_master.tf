module "puppet_master_security_group" {
  source = "github.com/carlosonunez/terraform_modules/aws/ec2/security_groups/puppet_master"
  security_group_name = "${var.puppet_master_security_group_name}"
  vpc_id = "${var.ec2_vpc_id}"
  source_cidr_blocks = "${var.ec2_vpc_cidr_block}"
  security_group_tags = "${var.ec2_tags}"
}

module "puppet_master_instances" {
  source = "github.com/carlosonunez/terraform_modules/aws/ec2/instances/puppet_master"
  ami_id = "${var.puppet_master_ami_id}"
  number_of_instances = "${var.puppet_master_number_of_instances}"

  // It would be nice to do a regex match on this instead of a simple length comparison, but
  // this was not available as of Terraform v0.8.
  subnet_id = "${length(var.puppet_master_subnet_id) > 0 ? var.puppet_master_subnet_id : var.ec2_subnet_id}"
  instance_type = "${var.puppet_master_instance_type}"
  instance_name = "${var.environment}-puppet_master"
  key_name = "${var.ec2_key_name}"
  private_key_path = "${var.ec2_private_key_path}"
  user_data = "${var.puppet_master_user_data}"
  tags = "${merge(var.global_infrastructure_tags, var.ec2_tags, var.puppet_master_tags)}"
  security_group_ids = [
    "${module.puppet_master_security_group.security_group_id}",
    "${var.ec2_default_ssh_access_sg_id}"
  ]
  create_route53_cname_resource_records = true
  route53_hosted_zone_id = "${var.route53_hosted_zone_id}"
  route53_rr_suffix = "puppet_master.${var.ec2_route53_rr_suffix}"
  puppet_master_docker_service_conf_location = "include/${var.environment}/files/etc/systemd/system/docker.service.d/custom.conf"
  puppet_master_provisioning_commands = "${var.puppet_master_provisioning_commands}"
}
