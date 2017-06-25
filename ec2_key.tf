module "ec2-instance-key" {
  source = "./modules/aws-ec2-key"
  key_name = "${var.environment}"
  key_pair = "${var.ec2_public_key}"
}
