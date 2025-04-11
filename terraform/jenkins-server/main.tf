data "aws_availability_zones" "azs" {}


resource "aws_security_group" "sg" {
  name = "jenkins-sg"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9000
    to_port     = 9000
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


resource "aws_instance" "instance" {
  ami                  = var.ami
  instance_type        = var.instance_type
  vpc_security_group_ids = [ aws_security_group.sg.id ]
  availability_zone    = data.aws_availability_zones.azs.names[0]
  iam_instance_profile = aws_iam_instance_profile.ec2_admin_instance_profile.name

  user_data = file("tools.sh")

  tags = {
    Name = "jenkins-server"
  }
}