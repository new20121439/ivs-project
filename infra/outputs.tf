output "website_endpoint" {
  value = module.website.website_bucket.website_endpoint
}

output "api_endpoint" {
  value = module.demo-ecs
}

output "test_token" {
  value = var.test_token
}

