variable "subnet_ids" {
  description = "List of subnet IDs for the load balancer"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID for the load balancer and target group"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID for the load balancer"
  type        = string
}

