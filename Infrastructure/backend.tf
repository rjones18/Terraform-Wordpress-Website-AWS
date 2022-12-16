terraform {
  backend "s3" {
    bucket         = "ta-challenge-wp-team-2"
    key            = "Talent-Academy/labs/application-infrastructure/terraform.tfstates"
    dynamodb_table = "terraform-lock"
  }
}