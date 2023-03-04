resource "aws_instance" "my-ec2" {
  ami           = "ami-0f3c9c466bb525749"
  instance_type = "t2.micro"
  vpc_security_group_ids =[aws_security_group.demo-sg.id]
  tags = {
    Name = "moalaa-ec2-instance"
  }
}

resource "aws_eip" "my-eip" {
  vpc = true
}


resource "aws_eip_association" "associate" {
  instance_id   = aws_instance.my-ec2.id
  allocation_id = aws_eip.my-eip.id

}

output "public_ip" {
  description = "VMs Public IP"
  value       = aws_instance.my-ec2.public_ip
}

output "private_ip" {
  description = "VMs Private IP"
  value       = aws_instance.my-ec2.private_ip
}

output "host_id" {
  value = aws_instance.my-ec2.host_id
}


terraform {
  backend "s3" {
    bucket = "moalaaitidevops"
    key    = "tf_store"
    region = "us-east-2"
  }
}
resource "aws_security_group" "demo-sg" {
  name = "sec-grp"
  description = "Allow HTTP and SSH traffic via Terraform"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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