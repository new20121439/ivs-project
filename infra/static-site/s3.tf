resource "aws_s3_bucket" "website_bucket" {
  bucket = var.website_bucket_name

  tags = {
    Name        = "website"
    Environment = var.environment
  }

  policy = <<EOF
    {
      "Version": "2008-10-17",
      "Statement": [
        {
          "Sid": "PublicReadForGetBucketObjects",
          "Effect": "Allow",
          "Principal": {
            "AWS": "*"
          },
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::${var.website_bucket_name}/*"
        }
      ]
    }
  EOF

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}
