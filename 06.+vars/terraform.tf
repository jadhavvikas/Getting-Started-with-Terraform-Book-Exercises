resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
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

resource "aws_security_group" "defaultSG" {
  name = "DefaultSG"
  description = "Allow SSH Access"
  vpc_id = "${aws_vpc.myvpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

module "mighty_trousers" {
  source = "./modules/application"
  vpc_id = "${aws_vpc.myvpc.id}"
  subnet_id = "${aws_subnet.public.id}"
  environment = "${var.environment}"
  extra_sgs = ["${aws_security_group.defaultSG.id}"]
  name = "MightyTrousers"
}
output "inst_m" {
  value = "${module.mighty_trousers.hostname-inst}"
}