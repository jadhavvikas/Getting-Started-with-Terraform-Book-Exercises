variable "vpc_id" {}
variable "subnet_id" {} 
variable "name" {}
resource "aws_security_group" "allow_http" {
  name = "${var.name} Allow HTTP"
  description = "${var.name} Allow HTTP Traffic From All"
  vpc_id = "${var.vpc_id}"
  tags {
    Name = "${var.name}"
  }

  ingress {
    description = "${var.name} Allow 80"
    from_port = 80
    to_port = 80
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
resource "aws_instance" "inst" {
  ami = "ami-009d6802948d06e52"
  instance_type = "${lookup(var.instance_type, var.environment)}"
  subnet_id = "${var.subnet_id}"
  #vpc_security_group_ids = ["${aws_security_group.allow_http.id}"]
  #vpc_security_group_ids = ["${concat(var.extra_sgs,aws_security_group.allow_http.id)}"]
  vpc_security_group_ids = ["${distinct(concat(var.extra_sgs, aws_security_group.allow_http.*.id))}"]
  tags {
    Name = "${var.name}"
  }
}

output "hostname-inst" {
  value = "${aws_instance.inst.public_dns}"
}
