resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags {
    Name = "MyVpc"
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
resource "aws_key_pair" "dk" {
  key_name = "lab-default"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCd4El9R2q73YLFzBUOoSahNqIWwff3+OUUn2k9H+zkwl/qUEtHXcNRVn8eHlnkeGZrAqGZ8wpSXp7mquvE3+xdiB0OOHDOBgI0fUFyVENFOoZNaTWyTU9kWz6EkGx9UAdH2CxonJi0idjLlAM3Fe+lyjL8SMpylhsh2mAysJ89qHojppV46TG3V9jzs33xVq/pgEIQtOGrxv/gr7ga+ssCve8Y9Tf1diMZVS+MwsctBtGlEicnm9XHocbvFqzVldNMDL6AmDrheoT5qi1XV+gBkIY8/IqtX3X6h/oBwiqWL4dRk7S9b1Q61V6OiFNTfRNKQQp/Cr0WuuaR0LibyARF witalo@MDC-2794"
}

resource "aws_security_group" "allow_http" {
  name = "Allow Http"
  description = "Allow HTTP Traffic From All"
  vpc_id = "${aws_vpc.myvpc.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "mighty-trousers" {
    ami = "ami-009d6802948d06e52"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public.id}"
  key_name = "${aws_key_pair.dk.id}"
  vpc_security_group_ids = ["${aws_security_group.allow_http.id}"]
  tags {
    Name = "Mighty Trousers"
  }
}