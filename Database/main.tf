data "aws_vpc" "main_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "data-a" {
  filter {
    name   = "tag:Name"
    values = [var.data_a_subnet_name]
  }
}

data "aws_subnet" "data-b" {
  filter {
    name   = "tag:Name"
    values = [var.data_b_subnet_name]
  }
}

data "aws_secretsmanager_secret" "secrets" {
  arn = "arn:aws:secretsmanager:us-east-1:614768946157:secret:wordpress_creds-WV93BC"
}
data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}



#output "aws_secretsmanager_secret" {
#value = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.current.secret_string)) ["wordpress_password"]
#}