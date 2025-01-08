terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-proj"  # Replace with your unique S3 bucket name
    key    = "terraform/prac-task/statefile.tfstate"  # Path inside the bucket for the state file
    region = "us-east-1"  # AWS region for your S3 bucket
    encrypt = true  # Enable encryption for the state file

    # Optional: DynamoDB for state locking
    dynamodb_table = "terraform-locks"  # The DynamoDB table name (ensure this exists)
    acl            = "bucket-owner-full-control"  # Optional ACL (access control list)
  }
}
provider "aws" {
  region = "us-east-1"
}

module "compute" {
  source = "./modules/compute"
  ami_id = "ami-02dcfe5d1d39baa4e"
  instance_type = "t4g.nano"
  key_name = "tertest"
  subnet_id = "subnet-08c014a03f05f15d5"
  security_group_id = "sg-0800ec602a5fec60d"
  subnet_ids         = ["subnet-08c014a03f05f15d5", "subnet-09b7a8e3aa2b1458c"]  # Define subnet IDs here
  vpc_id = "vpc-08ae06cdbd343a6e7"
  target_group_arn   = module.network.target_group_arn  # Pass the ARN of the target group
}

module "network" {
  source = "./modules/network"
  subnet_ids = ["subnet-08c014a03f05f15d5", "subnet-09b7a8e3aa2b1458c"]
  vpc_id = "vpc-08ae06cdbd343a6e7"
  security_group_id = "sg-0d5213ea33c3b0241"
}


