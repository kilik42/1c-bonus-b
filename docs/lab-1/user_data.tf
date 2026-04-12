# -----------------------------
# WINDOWS SERVER 2022 AMI LOOKUP
# -----------------------------
data "aws_ami" "windows_2022" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
}
resource "aws_vpc" "tetsuzai" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "tetsuzai-vpc"
  }
}
# -----------------------------
# EC2 INSTANCE (WINDOWS)
# -----------------------------
resource "aws_instance" "tetsuzai_app" {
  ami = data.aws_ami.windows_2022.id

  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  iam_instance_profile        = var.ssm_instance_profile
  key_name                    = null
  associate_public_ip_address = true


  # -----------------------------
  # WINDOWS POWERSHELL USERDATA
  # -----------------------------
  user_data_base64 = base64encode(<<-EOF
<powershell>

Start-Sleep -Seconds 60

Install-WindowsFeature -Name Web-Server -IncludeManagementTools

New-NetFirewallRule -DisplayName "Allow HTTP 80" `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort 80 `
  -Action Allow `
  -ErrorAction SilentlyContinue

Set-Content -Path "C:\inetpub\wwwroot\index.html" `
  -Value "<h1>Tetsuzai ALB Healthy</h1>"

</powershell>
EOF
  )





  tags = {
    Name = "tetsuzai-app-instance"
  }
}
