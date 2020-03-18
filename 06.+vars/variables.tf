variable "region" {
    description = "AWS Region, Changing it will lead to a complete loss of stack"
    default = "us-east-1"
}
variable "accesskey" {}
variable "secretkey" {}
variable "environment" { default = "dev"}