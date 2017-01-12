data "aws_ami" "ubuntu_latest" {
  most_recent = "true"
  filter {
    name = "owner-id"
    values = [ "099720109477" ]
  }
  filter {
    name = "name"
    values = [ "*ubuntu-trusty*" ]
  }
}
