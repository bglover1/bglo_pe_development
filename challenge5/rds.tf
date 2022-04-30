resource "aws_db_instance" "bensrds" {
  identifier             = "bensrds"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  username               = var.user_name
  password               = var.db_password
#  db_subnet_group_name   = aws_db_subnet_group.education.name
  vpc_security_group_ids = [aws_security_group.rds.id]
#  parameter_group_name   = aws_db_parameter_group.education.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

resource "aws_db_security_group" "rds" {
  name = "rds_sg"

  ingress {
    cidr = "100.67.16.0/22"
  }
}
