variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "aws_key_name" {
  type        = string
  description = "SSH key pair name stored in AWS"
}

variable "ssh_key_path" {
  type        = string
  description = "SSH key path on EC2 instance"
}

variable "ami_id" {
  type        = string
  description = "AMI id for EC2 instances"
}

variable "region" {
  type        = string
  description = "AWS region in which resources will be deployed"
  default     = "us-east-1"
}

variable "profile" {
  type        = string
  description = "AWS profile used to deploy resources. Use only when AWS profile is used."
  default     = "default"
}