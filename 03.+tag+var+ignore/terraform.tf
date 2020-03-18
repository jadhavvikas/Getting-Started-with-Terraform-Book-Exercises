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
resource "aws_instance" "master-instance" {
  ami = "ami-009d6802948d06e52"
  instance_type = "t2.micro"
  subnet_id ="${aws_subnet.public.id}"
  tags {
    Name = "Master"
  }
  }
resource "aws_instance" "slave-instace" {
  ami = "ami-009d6802948d06e52"
  instance_type = "t2.micro"
  subnet_id ="${aws_subnet.public.id}"
  depends_on = ["aws_instance.master-instance"]
  tags {
    Name = "Slave"
    master_hostname = "${aws_instance.master-instance.private_dns}"
    master_id = "${aws_instance.master-instance.id}"
    master_arn = "${aws_instance.master-instance.arn}"
  }
  #lifecycle {
  #  ignore_changes = ["tags"]
  #}
}

