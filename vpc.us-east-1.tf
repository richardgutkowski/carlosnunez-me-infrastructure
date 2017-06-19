resource "aws_vpc" "infrastructure" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "vpc.carlosnunez.me"
    Environment = "dev"
  }
}
