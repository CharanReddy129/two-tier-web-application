terraform {
  backend "s3" {
    bucket       = "demo-s3-bucket-tf"
    key          = "two-tier-app/jenkins-server/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}