resource "aws_key_pair" "keypair" {
  key_name = "${var.ec2_key_name}"
  public_key = "${var.public_key}"
}
