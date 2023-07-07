terraform {
  backend "s3" {
    bucket         = "reggie-talent-academy-686520628199-tfstates"
    key            = "Talent-Academy/labs/application-infrastructure/terraform.tfstates"
    dynamodb_table = "terraform-lock"
  }
}