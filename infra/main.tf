provider "aws" {
  region = "ap-southeast-1"
}

module "website" {
  source              = "./static-site"
  domain_name         = var.domain_name
  environment         = var.environment
  website_bucket_name = var.website_bucket_name
}
