terraform {
  backend "s3" {
    bucket = "primuslearning-app237"
    region = "us-east-1"
    key = "eks/terraform.tfstate"
  }
}