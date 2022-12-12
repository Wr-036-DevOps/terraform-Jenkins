# Variable that holds the CIDR block for the VPC
variable "vpc_cidr_block" {
    description = "CIDR block of the VPC"
}

# Creting the VPC 
resource "aws_vpc" "jenkins_vpc" {
    # Setting the CIDR block of the VPC to the variable vpc_cidr_block
    cidr_block = var.vpc_cidr_block

    # Enabling DNS hostnames on the VPC
    enable_dns_hostnames = true

    # Setting the tag Name to tutorial_vpc
    tags = {
        Name = "jenkins_vpc"
        ita_group = "Wr-36"
    }
}

# Creating the Internet Gateway 
resource "aws_internet_gateway" "jenkins_vpc_igw" {
    # Attaching it to the VPC called tutorial_vpc
    vpc_id = aws_vpc.jenkins_vpc.id

    # Setting the Name tag to tutorial_igw
    tags = {
        Name = "jenkins_vpc_igw"
        ita_group = "Wr-36"
    }
}

# Creating the public route table 
resource "aws_route_table" "jenkins_vpc_public_rt" {
    # Creating it inside the tutorial_vpc VPC
    vpc_id = aws_vpc.jenkins_vpc.id

    # Adding the internet gateway to the route table
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.jenkins_vpc_igw.id
    }
}

# Variable that holds the CIDR block for the public subnet
variable "public_subnet_cidr_block" {
    description = "CIDR block of the public subnet"
}

# Data store that holds the available AZs in our region
data "aws_availability_zones" "available" {
    state = "available"
}

# Creating the public subnet 
resource "aws_subnet" "jenkins_public_subnet" {
    # Creating it inside the tutorial_vpc VPC
    vpc_id = aws_vpc.jenkins_vpc.id

    # Setting the CIDR block to the variable public_subnet_cidr_block
    cidr_block = var.public_subnet_cidr_block

    # Setting the AZ to the first one in our available AZ data store
    availability_zone = data.aws_availability_zones.available.names[0]

    # Setting the tag Name to "tutorial_public_subnet"
    tags = {
        Name = "jenkins_public_subnet"
        ita_group = "Wr-36"
    }
}

# Associating our public subnet with our public route table
resource "aws_route_table_association" "public" {
    # The ID of our public route table 
    route_table_id = aws_route_table.jenkins_vpc_public_rt.id

    # The ID of our public subnet 
    subnet_id = aws_subnet.jenkins_public_subnet.id
}