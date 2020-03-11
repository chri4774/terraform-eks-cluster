variable "cluster-name" {
  default = "cs-terraform-eks-demo"
  type    = string
}

variable "key_name" {
  default = "sshkey1"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "aws_profile" {
  default     = "eks"
  description = "configure AWS CLI profile"
}

variable "region" {
  description = "Enter region you want to create EKS cluster in"
  default     = "eu-central-1"
}

variable "availability_zone_count" {
  default = 3
}