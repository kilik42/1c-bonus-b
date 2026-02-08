# build the security group for tokyo region
resource "aws_security_group" "tokyo_public_sg" {   
    provider = aws.tokyo
    name        = "tokyo_public_sg"
    description = "Allow SSH and HTTP traffic"
    vpc_id      = aws_vpc.tokyo_vpc.id
    
    ingress {
        description      = "SSH from anywhere"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

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
        Name = "tokyo_public_sg"
    }
}