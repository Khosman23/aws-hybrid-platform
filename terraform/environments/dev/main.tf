terraform {
  required_version = ">= 1.7.0"

  backend "s3" {
    bucket         = "hybrid-platform-tfstate-413612133747"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "hybrid-platform-tflock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = "aws-hybrid-platform"
      Environment = "dev"
      ManagedBy   = "terraform"
    }
  }
}

module "vpc" {
  source             = "../../modules/vpc"
  project_name       = "hybrid-platform"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
}

module "eks" {
  source             = "../../modules/eks"
  project_name       = "hybrid-platform"
  private_subnet_ids = module.vpc.private_subnet_ids
  desired_nodes      = 2
  min_nodes          = 1
  max_nodes          = 3
}

module "ecr" {
  source          = "../../modules/ecr"
  repository_name = "hybrid-platform-app"
}

module "lambda" {
  source       = "../../modules/lambda"
  project_name = "hybrid-platform"
  account_id   = "413612133747"
}

output "api_endpoint" {
  value = module.lambda.api_endpoint
}

output "s3_bucket_name" {
  value = module.lambda.s3_bucket_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "cluster_name" {
  value = module.eks.cluster_name
}