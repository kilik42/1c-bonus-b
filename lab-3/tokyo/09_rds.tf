# create rds for tokyo region
resource "aws_db_instance" "tokyo_db_instance" {
  provider = aws.tokyo
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "tokyodb"
  username             = "admin"
  password             = "password1234"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
    tags = {
        Name = "tokyo_db_instance"
    }
}


