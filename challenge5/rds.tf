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

resource "aws_security_group" "rds_sg" {
  name = "rds-sg"

    ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
