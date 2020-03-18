resource "aws_vpc" "myvpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags {
    Name = "MyVpc"
  }
}
resource "aws_subnet" "mysubnet" {
  vpc_id = "${aws_vpc.myvpc.id}"
  cidr_block = "${lookup(var.subnet_cidr, var.subnet)}"
  map_public_ip_on_launch = "${lookup(var.map_ip_clause, var.map_ip)}"
      tags {
    Name = "${var.subnet} Subnet"
  }
}

resource "aws_internet_gateway" "mygw" {
  vpc_id = "${aws_vpc.myvpc.id}"
  tags {
    Name = "My IGW"
  }
}

resource "aws_default_route_table" "defaultRT" {
  default_route_table_id = "${aws_vpc.myvpc.default_route_table_id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.mygw.id}"
  }
}

#resource "aws_route_table" "myrt" {
#  vpc_id = "${aws_vpc.myvpc.id}"
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = "${aws_internet_gateway.mygw.id}"
#  }
#  tags {
#    Name = "My Route Table"
#  }
#}


#resource "aws_main_route_table_association" "main" {
#  vpc_id = "${aws_vpc.myvpc.id}"
#  route_table_id = "${aws_route_table.myrt.id}"
#}
resource "aws_security_group" "defaultSG" {
  name = "DefaultSG"
  description = "DefaultSG On Root Tf"
  vpc_id = "${aws_vpc.myvpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = "${var.allow_ssh_access}"
    }
}

module "mighty_trousers" {
  source = "./modules/application"
  vpc_id = "${aws_vpc.myvpc.id}"
  subnet_id = "${aws_subnet.mysubnet.id}"
  environment = "${var.environment}"
  extra_sgs = ["${aws_security_group.defaultSG.id}"]
  name = "MightyTrousers"
}
output "inst_m" {
  value = "${module.mighty_trousers.hostname-inst}"
}