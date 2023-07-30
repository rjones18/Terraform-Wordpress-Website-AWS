# DEFINING ALL VARIABLES
variable "aws_owner_id" {
  description = "Contains the Owner ID of the ami for amazon linux"
  type        = string
}

variable "aws_ami_name" {
  description = "Name of the ami I want for my project"
  type        = string
}

variable "vpc_name" {
  description = "Name of the vpc for my project"
  type        = string
}

variable "ec2_type" {
  description = "Type of my ec2 instance"
  type        = string
  default     = "t2.small"
}

variable "public_a_subnet_name" {
  type = string
}

variable "public_b_subnet_name" {
  type = string
}

variable "private_a_subnet_name" {
  type = string
}

variable "private_b_subnet_name" {
  type = string
}
variable "my_keypair" {
  default = "aws_keypair"
}

variable "number_of_private_instances" {
  description = "Amount of instances for my Private subnet"
}