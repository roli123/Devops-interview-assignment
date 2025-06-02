variable "aws_region" {
  description = "The AWS region to deploy the resources."
  default     = "us-west-2" # Change as necessary
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  default     = "my-eks-cluster"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones for the VPC."
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "desired_capacity" {
  description = "Desired number of instances in the node group."
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of instances in the node group."
  default     = 3
}

variable "min_capacity" {
  description = "Minimum number of instances in the node group."
  default     = 1
}