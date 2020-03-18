resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags {
    Name = "MyVpc2"
  }
}


resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.myvpc.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch  = "true"
  tags {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.myvpc.id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  tags {
    Name = "Private Subnet"
  }
}