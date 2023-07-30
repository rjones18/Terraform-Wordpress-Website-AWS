resource "aws_db_subnet_group" "database-subnet-group" {
  name        = "database subnets"
  subnet_ids  = [data.aws_subnet.data-a.id, data.aws_subnet.data-b.id]
  description = "Subnet for Databaase Instance"
  tags = {
    Name = "My DB subnet group"
  }
}
# Create Database Instance
resource "aws_db_instance" "database-instance" {
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  identifier              = "wordpress"
  db_name                 = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.current.secret_string))["wordpress_db_name"]
  username                = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.current.secret_string))["wordpress_username"]
  password                = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.current.secret_string))["wordpress_password"]
  multi_az                = true
  db_subnet_group_name    = aws_db_subnet_group.database-subnet-group.name
  vpc_security_group_ids  = [aws_security_group.database-security-group.id]
  skip_final_snapshot     = true
  backup_retention_period = 1
}












