resource "aws_instance" "tetsuzai_app" {
  ami                    = "ami-07a73e7966fb8ae9d" # Windows Server 2025
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.app_sg_id]
  iam_instance_profile   = var.ssm_instance_profile
  key_name               = null

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
