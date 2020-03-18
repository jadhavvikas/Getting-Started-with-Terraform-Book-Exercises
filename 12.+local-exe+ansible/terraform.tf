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
resource "aws_security_group" "defaultSG" {
  name = "DefaultSG"
  description = "Allow SSH Access"
  vpc_id = "${aws_vpc.myvpc.id}"
  tags {
    Name = "Allow SSH Access"
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = "${var.allow_ssh_access}"
    }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = "${var.allow_ssh_sebastiao}"
    }
}

module "mighty_trousers" {
  source = "./modules/application"
  vpc_id = "${aws_vpc.myvpc.id}"
  subnet_id = "${aws_subnet.mysubnet.id}"
  environment = "${var.environment}"
  extra_sgs = ["${aws_security_group.defaultSG.id}"]
  extra_packages = "${lookup(var.extra_packages,"MightyTrousers")}"
  #extra_packages = "${var.extra_packages}"
  external_nameserver = "${var.external_nameserver}"
  name = "MightyTrousers"
}
output "inst_m" {
  value = "${module.mighty_trousers.hostname-inst}"
}

output "publicIP" {
  value = "${module.mighty_trousers.publicIP}"
}
