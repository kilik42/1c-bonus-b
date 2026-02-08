# create the alb for tokyo region
resource "aws_lb" "tokyo_alb" {
  provider = aws.tokyo
  name               = "tokyo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tokyo_alb_sg.id]
  subnets            = [aws_subnet.tokyo_public_subnet_1.id]

  tags = {
    Name = "tokyo_alb"
  }
}

# create the security group for alb
resource "aws_security_group" "tokyo_alb_sg" {
  provider = aws.tokyo
  name        = "tokyo_alb_sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = aws_vpc.tokyo_vpc.id
  
  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    egress {
        description      = "Allow all outbound traffic"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }
    tags = {
        Name = "tokyo_alb_sg"
    }
}

