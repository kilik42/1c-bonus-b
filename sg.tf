resource "aws_security_group" "ec2_sg" {
  name        = "tetsuzai-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow ALB to reach EC2"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    security_groups = [
      aws_security_group.alb_sg.id
      # "sg-0747b62d9f7229a20"
    ]
    # security_groups  = ["sg-0747b62d9f7229a20"]
    # cidr_blocks      = []
    # ipv6_cidr_blocks = []
    # prefix_list_ids  = []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
