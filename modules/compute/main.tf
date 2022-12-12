# Variable where we will pass our Jenkins security group ID 
variable "security_group" {
    description = "The security groups assigned to the Jenkins server"
}

variable  "jenkins_role" {
    description = "id of the jenkins role to be assigned to the server"
}

# Variable where we will pass in the subnet ID
variable "public_subnet" {
    description = "The public subnet IDs assigned to the Jenkins server"
}

variable "ami_id" {
    description = "ami_id of the golden image"
    type = string
}

# This data store is holding the most recent ubuntu 20.04 image
data "aws_ami" "ubuntu" {
    most_recent = "true"

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}


resource "aws_iam_instance_profile" "jenkins_profile" {
    name  = "jenkins_profile"
    role = var.jenkins_role
}

# Creating an EC2 instance called jenkins_server
resource "aws_instance" "jenkins_server" {
    # Setting the AMI to the ID of the Ubuntu 20.04 AMI from the data store
    ami = data.aws_ami.ubuntu.id

    # Setting the subnet to the public subnet we created
    subnet_id = var.public_subnet

    # Setting the instance type to t2.micro
    instance_type = "t2.micro"

    # Setting the security group to the security group we created
    vpc_security_group_ids = [var.security_group]

    # Setting the key pair name to the key pair we created
    key_name = aws_key_pair.jenkins_kp.key_name

    #Attaching the instance profile
    iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name

    # Setting the user data to the bash file called install_jenkins.sh
    user_data = "${file("${path.module}/install_jenkins.sh")}"

    # Setting the Name tag to jenkins_server
    tags = {
        Name = "jenkins_server"
        ita_group = "Wr-36"
    }
    volume_tags = {
        ita_group = "Wr-36"
    }
}

# Creating a key pair in AWS 
resource "aws_key_pair" "jenkins_kp" {
    # Naming the key 
    key_name   = "jenkins_kp"

    # Passing the public key of the key pair we created
    public_key = "Path to public key pair" #file("${path.module}/jenkins_kp.pub")
}

# Creating an Elastic IP called jenkins_eip
resource "aws_eip" "jenkins_eip" {
    # Attaching it to the jenkins_server EC2 instance
    instance = aws_instance.jenkins_server.id

    # Making sure it is inside the VPC
    vpc      = true

    # Setting the tag Name to jenkins_eip
    tags = {
        Name = "jenkins_eip"
    }
}