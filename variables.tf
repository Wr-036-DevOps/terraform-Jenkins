variable "aws_region" {
    default = "eu-central-1"
}

variable "vpc_cidr_block" {
    description = "CIDR block for VPC"
    type = string
    default = "10.10.0.0/16"
}

variable "public_subnet_cidr_block" {
    description = "CIDR block for public subnet"
    type = string
    default = "10.10.1.0/24"
}

variable "my_ip" {
    description = "Your IP address"
    type = string
    sensitive = true
}

variable "ami_id" {
    description = "ami id of golden image"
    type = string
    sensitive = true
}