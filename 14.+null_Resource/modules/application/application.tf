variable "vpc_id" {}
variable "subnet_id" {}
variable "name" {}

resource "random_id" "rdid" {
  byte_length = 10
}

resource "random_shuffle" "elemento" {
  input        = ["agua", "fogo", "ar", "terra"]
  result_count = 1
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user_data_sh.tpl")}"
  vars {
    packages   = "${var.extra_packages}"
    nameserver = "${var.external_nameserver}"
    id         = "${random_id.rdid.b64}"
    elemento   = "${random_shuffle.elemento.result[0]}"
  }
}

resource "aws_key_pair" "terraform" {
  key_name   = "terraform"
  public_key = "${file("${path.module}/mykey.pub")}"
}

resource "aws_security_group" "allow_http" {
  name        = "${var.name} Allow HTTP"
  description = "${var.name} Allow HTTP Traffic From All"
  vpc_id      = "${var.vpc_id}"
  tags {
    Name = "${var.name}"
  }

  ingress {
    protocol  = "-1"
    self      = true
    from_port = 0
    to_port   = 0
  }

  ingress {
    description = "${var.name} Allow 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "inst" {
  ami           = "ami-009d6802948d06e52"
  key_name      = "${aws_key_pair.terraform.id}"
  instance_type = "${lookup(var.instance_type, var.environment)}"
  subnet_id     = "${var.subnet_id}"
  vpc_security_group_ids = ["${distinct(concat(var.extra_sgs, aws_security_group.allow_http.*.id))}"]
  user_data = "${data.template_file.user_data.rendered}"
    connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("./mykey")}"
  }
    provisioner "remote-exec" {
    inline = [
      "sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm",
      "sudo yum install puppet -y",
    ]
  }
  tags {
    Name = "${var.name}"
  }

  lifecycle {
    ignore_changes = ["user_data"]
  }
}

resource "null_resource" "server-provisioner" {
  triggers = {
    server_id  = "${aws_instance.inst.id}"
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("./mykey")}"
    host = "${aws_instance.inst.public_ip}"
  }
  provisioner "file" {
    source     = "${path.module}/setup.pp"
    destination = "/tmp/setup.pp"
  }
    provisioner "remote-exec" {
    inline = [
      "sudo puppet apply /tmp/setup.pp",
    ]
}
}

output "hostname-inst" {
  value = "${aws_instance.inst.public_dns}"
}

output "publicIP" {
  value = "${aws_instance.inst.public_ip}"
}
