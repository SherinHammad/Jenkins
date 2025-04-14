terraform {
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" 
  }

# Generate a new SSH key pair
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create the AWS key pair using the generated public key
resource "aws_key_pair" "mykey" {
  key_name   = "my-key"
  public_key = tls_private_key.example.public_key_openssh
}

# Save the private key to a local file
resource "local_file" "private_key" {
  content  = tls_private_key.example.private_key_pem
  filename = "${path.module}/my-key.pem"
  file_permission = "0400"
}

resource "aws_instance" "web" {
  ami                    = "ami-084568db4383264d4"  # Ubuntu us-east-1
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.mykey.key_name  # Correct reference
  associate_public_ip_address = true

  tags = {
    Name = "Jenkins-Ansible-EC2"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "private_key_pem" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}

