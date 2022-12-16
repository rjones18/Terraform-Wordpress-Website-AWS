terraform {
  backend "s3" {
    bucket         = "ta-challenge-wp-team-2"
    key            = "Talent-Academy/labs/RDS_Database/terraform.tfstates"
    dynamodb_table = "terraform-lock"
  }
}