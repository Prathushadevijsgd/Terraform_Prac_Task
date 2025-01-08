variable "ami_id" {
  description = "The ID of the AMI to launch"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
}

variable "key_name" {
  description = "The SSH key name"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID for the instance"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Auto Scaling Group"
  type        = list(string)
}

variable "target_group_arn" {
  description = "The ARN of the target group"
  type        = string
}

