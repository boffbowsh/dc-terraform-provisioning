terraform {
  backend "s3" {
    bucket     = "democracyclub-terraform-state"
    key        = "electionleaflets.tfstate"
    region     = "eu-west-2"
    kms_key_id = "99a1dc31-2358-4936-915a-ad96e07ac0de"
    encrypt    = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_region" "current" {
  current = true
}

provider "credstash" {
    table  = "credential-store"
    region = "eu-west-1"
}
