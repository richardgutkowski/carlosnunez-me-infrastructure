resource "aws_key_pair" "keypair" {
  key_name = "${var.ec2_key_name}"
  public_key = "${var.ec2_public_key}"
}
