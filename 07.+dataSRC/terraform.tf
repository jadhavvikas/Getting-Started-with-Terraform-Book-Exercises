data "aws_vpc" "management_layer" {
  id = "vpc-f685a68f"
}


resource "aws_vpc" "myvpc" {
  cidr_block = "${var.vpc_cidr}"
  tags {
    Name = "MyVpc"
  }
}

resource "aws_vpc_peering_connection" "my_peer" {
  peer_vpc_id =  "${data.aws_vpc.management_layer.id}"
  vpc_id = "${aws_vpc.myvpc.id}"
  auto_accept = true
}
