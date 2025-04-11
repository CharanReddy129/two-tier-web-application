variable "region" {
  description = "This contains the region of the aws resources"
  type        = string
  default     = "ap-south-1"
}

variable "ami" {
  description = "This contains the ami of the ec2 instance"
  type        = string
  default     = "ami-0e35ddab05955cf57"
}

variable "instance_type" {
  description = "This contains the instance type"
  type        = string
  default     = "t2.micro"
}

