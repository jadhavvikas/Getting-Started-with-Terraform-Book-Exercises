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
module "mighty_trousers" {
  source = "./modules/application"
  vpc_id = "${aws_vpc.myvpc.id}"
  subnet_id = "${aws_subnet.public.id}"
  name = "MightyTrousers"
}

module "crazy_foods" {
  source = "./modules/application"
  vpc_id = "${aws_vpc.myvpc.id}"
  subnet_id = "${aws_subnet.public.id}"
  name  = "CrazyFoods"
}

output "inst_m" {
  value = "${module.mighty_trousers.hostname-inst}"
}

output "inst_C" {
  value = "${module.crazy_foods.hostname-inst}"
}
