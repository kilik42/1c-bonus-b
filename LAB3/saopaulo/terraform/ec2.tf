# Look up a current Amazon Linux 2023 AMI for the São Paulo region.
# Using a data source keeps the build from depending on a stale hardcoded AMI ID.
data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# São Paulo secondary-region application instance.
# For the first pass I am placing it in a public subnet so bootstrap/install steps work cleanly.
# The long-term architecture idea is still a secondary compute tier connected back to the primary data region.
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              set -euo pipefail

              dnf update -y
              dnf install -y python3

              cat >/home/ec2-user/index.html <<'HTML'
              <html>
              <head><title>LAB3 São Paulo Secondary App</title></head>
              <body>
                <h2>LAB3A São Paulo Secondary Region</h2>
                <p>This is the stateless secondary-region application tier.</p>
                <p>Primary data authority remains in the Tokyo logical region.</p>
              </body>
              </html>
              HTML

              cd /home/ec2-user
              nohup python3 -m http.server ${var.app_port} >/var/log/lab3-http.log 2>&1 &
              EOF

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-app-server"
  })
}

# Register the São Paulo app instance with the ALB target group.
# This makes the regional ALB route traffic to the secondary compute host.
resource "aws_lb_target_group_attachment" "app_attach" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_server.id
  port             = var.app_port
}