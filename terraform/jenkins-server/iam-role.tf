# create a IAM role
resource "aws_iam_role" "ec2_admin_role" {
  name = "EC2AdministratorRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach AdministratorAccess Policy
resource "aws_iam_role_policy_attachment" "admin_access" {
  role       = aws_iam_role.ec2_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Create Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_admin_instance_profile" {
  name = "EC2AdminInstanceProfile"
  role = aws_iam_role.ec2_admin_role.name
}