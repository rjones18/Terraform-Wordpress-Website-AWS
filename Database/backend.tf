terraform {
  backend "s3" {
    bucket         = "reggie-talent-academy-686520628199-tfstates"
    key            = "Talent-Academy/labs/RDS_Database/terraform.tfstates"
    dynamodb_table = "terraform-lock"
  }
}