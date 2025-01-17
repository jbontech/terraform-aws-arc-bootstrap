################################################
## defaults
################################################
terraform {
  required_version = "~> 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

################################################
## imports
################################################
# data "aws_partition" "current" {} // uncomment this when using this module anywhere

# data "aws_caller_identity" "current" {} // uncomment this when using this module anywhere

module "tags" {
  source      = "sourcefuse/arc-tags/aws"
  version     = "1.2.2"
  environment = var.environment
  project     = "arc"

  extra_tags = {
    Repo         = "github.com/sourcefuse/terraform-module-aws-bootstrap"
    MonoRepo     = "True"
    MonoRepoPath = "terraform/bootstrap"
  }
}

module "bootstrap" {
  source                   = "sourcefuse/arc-bootstrap/aws"
  version                  = "1.0.9"
  bucket_name              = var.bucket_name
  dynamodb_name            = var.dynamodb_name
  dynamo_kms_master_key_id = var.dynamo_kms_master_key_id

  tags = merge(module.tags.tags, tomap({
    Name         = var.bucket_name
    DynamoDBName = var.dynamodb_name
  }))

}
