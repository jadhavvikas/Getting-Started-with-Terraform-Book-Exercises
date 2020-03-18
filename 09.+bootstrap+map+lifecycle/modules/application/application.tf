variable "vpc_id" {}
variable "subnet_id" {} 
variable "name" {}
data "template_file" "user_data" {
  template = "${file("${path.module}/user_data_sh.tpl")}"
  vars {
    packages = "${var.extra_packages}"
    nameserver = "${var.external_nameserver}"
  }
}resource "aws_key_pair" "terraform" {
  key_name = "terraform"
  public_key = "${file("${path.module}/mykey.pub")}"
  #public_key = "${file("./mykey.pub")}"
  }

resource "aws_security_group" "allow_http" {
  name = "${var.name} Allow HTTP"
  description = "${var.name} Allow HTTP Traffic From All"
  vpc_id = "${var.vpc_id}"
  tags {
    Name = "${var.name}"
  }
  ingress {
    protocol = "-1"
    self = true
    from_port = 0
    to_port = 0
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
  #ami = "${data.aws_ami.app-ami.id}"
  ami = "ami-009d6802948d06e52"
  key_name = "${aws_key_pair.terraform.id}"
  instance_type = "${lookup(var.instance_type, var.environment)}"
  subnet_id = "${var.subnet_id}"
  #vpc_security_group_ids = ["${aws_security_group.allow_http.id}"]
  #vpc_security_group_ids = ["${concat(var.extra_sgs,aws_security_group.allow_http.id)}"]
  vpc_security_group_ids = ["${distinct(concat(var.extra_sgs, aws_security_group.allow_http.*.id))}"]
  user_data = "${data.template_file.user_data.rendered}"
  tags {
    Name = "${var.name}"
  }
  lifecycle {
    ignore_changes = ["user_data"]
  }
}

output "hostname-inst" {
  value = "${aws_instance.inst.public_dns}"
}