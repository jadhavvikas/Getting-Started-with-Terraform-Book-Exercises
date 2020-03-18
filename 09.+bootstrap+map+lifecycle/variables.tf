variable "region" {}
variable "accesskey" {}
variable "secretkey" {}
variable "environment" { default = "dev"}

variable "subnet" { default = "public"}

variable "map_ip" { default = "public"}

variable "allow_ssh_access" {
    description = "List of CIDR blocks that can access instances via ssh"
    default = ["0.0.0.0/0"]
}
variable "vpc_cidr" {
    description = " VPC Network"
    default = "172.16.0.0/16"
}
variable "subnet_cidr" {
    description = "CIDR for public and private subnet"
    default = {
        public = "172.16.1.0/24"
        private = "172.16.2.0/24"         
    }
}

variable "map_ip_clause" {
  default = {
      public = "true"
      private = "false"
  }
}

variable "external_nameserver" {
  default = "8.8.8.8"
}
variable "extra_packages" {
  description = "Additional Packages to install for particular module"
  default = {
    base = "htop"
    MightyTrousers = "wget bind-utils httpd htop"
  }    
}