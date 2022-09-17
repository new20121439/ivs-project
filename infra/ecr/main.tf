resource "aws_ecr_repository" "demo-ecr-repository" {
  name                 = "node-app"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository_policy" "demo-ecr-policy" {
  repository = aws_ecr_repository.demo-ecr-repository.name

  policy = <<EOF
      {
        "Version": "2008-10-17",
        "Statement": [
          {
            "Sid": "adds full ecr access to the demo repository",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
          }
        ]
      }
  EOF
}
