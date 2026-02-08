# create rds for tokyo region
resource "aws_db_instance" "tokyo_db_instance" {
  provider                = aws.tokyo
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = "tokyodb"

  username                = var.db_username
  password                = var.db_password

  db_subnet_group_name    = aws_db_subnet_group.tokyo_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.tokyo_db_sg.id]

  skip_final_snapshot     = true

  tags = {
    Name = "tokyo_db_instance"
  }
}



# Fix your RDS file (it still needs subnet group + SG)
# create subnet group for rds
resource "aws_db_subnet_group" "tokyo_db_subnet_group" {
  provider = aws.tokyo
  name       = "tokyo-db-subnet-group"
  subnet_ids = [
    aws_subnet.tokyo_private_subnet_1.id,
    aws_subnet.tokyo_private_subnet_2.id
  ]

  tags = {
    Name = "tokyo-db-subnet-group"
  }
}


# build security group for rds
resource "aws_security_group" "tokyo_db_sg" {
  provider    = aws.tokyo
  name        = "tokyo-db-sg"
  description = "Allow MySQL from Tokyo EC2 and Sao Paulo VPC"
  vpc_id      = aws_vpc.tokyo_vpc.id

  ingress {
    description = "MySQL from Tokyo EC2 instances"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [
      aws_security_group.tokyo_public_sg.id   # EC2/ASG SG
    ]
  }

  ingress {
    description = "MySQL from Sao Paulo VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [ var.saopaulo_vpc_cidr ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tokyo-db-sg"
  }
}
