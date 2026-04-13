variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix for all resource names"
  type        = string
  default     = "hybrid-platform"
}

variable "owner" {
  description = "Your name, for tagging"
  type        = string
  default     = "devops-engineer"
}