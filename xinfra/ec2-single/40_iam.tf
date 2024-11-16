# CodeDeploy를 위한 EC2 IAM 역할
resource "aws_iam_role" "ec2_codedeploy_role" {
  name = "EC2CodeDeployRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "ec2-codedeploy-role"
  }
}

# CodeDeploy 서비스 역할
resource "aws_iam_role" "codedeploy_service_role" {
  name = "CodeDeployServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "codedeploy-service-role"
  }
}


# EC2 인스턴스 역할에 정책 연결
resource "aws_iam_role_policy_attachment" "ec2_codedeploy_s3" {
  role       = aws_iam_role.ec2_codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_codedeploy" {
  role       = aws_iam_role.ec2_codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

# CodeDeploy 서비스 역할에 정책 연결
resource "aws_iam_role_policy_attachment" "codedeploy_service" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

# EC2 인스턴스 프로파일 생성
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2CodeDeployProfile"
  role = aws_iam_role.ec2_codedeploy_role.name
}

# 현재 AWS 계정 ID를 가져오기 위한 데이터 소스
data "aws_caller_identity" "current" {}
