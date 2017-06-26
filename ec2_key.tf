module "ec2-instance-key" {
  source = "./modules/aws-ec2-key"
  key_name = "${var.ec2_key_name}"
  public_key = "${var.ec2_public_key}"
}
