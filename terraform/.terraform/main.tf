provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"  # Reemplaza con el ID de la AMI creada por Packer
  instance_type = "t2.micro"

  tags = {
    Name = "WebServer"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
