terraform {
  backend "s3" {
    bucket         = "wordpress-backups-maureen"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
