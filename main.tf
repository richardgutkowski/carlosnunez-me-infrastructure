resource "aws_vpc" "vpc.carlosnunez.me" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "vpc.carlosnunez.me"
    Environment = "dev"
  }
}
