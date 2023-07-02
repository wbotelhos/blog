terraform {
  backend "s3" {
    bucket         = "wbotelhos.com"
    dynamodb_table = "wbotelhos-com-terraform-locks"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "us-east-2"
  }

  required_version = ">= 0.13"

  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}
