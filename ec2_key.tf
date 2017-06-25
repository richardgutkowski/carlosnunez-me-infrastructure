module "ec2-instance-key" {
  source = "./modules/aws-ec2-key"
  key_name = "${var.ec2_key_name}"
  key_pair = "${var.ec2_public_key}"
}
