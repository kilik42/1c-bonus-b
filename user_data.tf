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
  ami                    = data.aws_ami.windows_2022.id

  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  iam_instance_profile         = var.ssm_instance_profile
  key_name                     = null
  associate_public_ip_address  = false

  # -----------------------------
  # WINDOWS POWERSHELL USERDATA
  # -----------------------------
  user_data = <<-EOF
<powershell>
# Enable logging
Start-Transcript -Path "C:\\userdata-log.txt" -Append

# Create working directory
New-Item -ItemType Directory -Force -Path "C:\\nginx"

# Download Nginx
Invoke-WebRequest -Uri "https://nginx.org/download/nginx-1.26.2.zip" -OutFile "C:\\nginx\\nginx.zip"

# Extract Nginx
Expand-Archive -Path "C:\\nginx\\nginx.zip" -DestinationPath "C:\\nginx" -Force

# Rename extracted folder to stable path
$extracted = Get-ChildItem -Directory "C:\\nginx" | Where-Object { $_.Name -like "nginx-*" }
Rename-Item -Path $extracted.FullName -NewName "C:\\nginx\\nginx"

# Create a simple index page
Set-Content -Path "C:\\nginx\\nginx\\html\\index.html" -Value "<h1>Tetsuzai App Server is Running</h1>"

# Start Nginx
Start-Process -FilePath "C:\\nginx\\nginx\\nginx.exe"

# Log completion
Write-Output "Nginx installation and startup complete."

Stop-Transcript
</powershell>
EOF

  tags = {
    Name = "tetsuzai-app-instance"
  }
}
