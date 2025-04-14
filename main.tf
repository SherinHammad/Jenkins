# terraform {
  
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

# # Configure the AWS Provider
# provider "aws" {
#   region = "us-east-1"  
# }


# # Generate a new SSH key pair
# resource "tls_private_key" "example" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# # Create the AWS key pair using the generated public key
# resource "aws_key_pair" "mykey" {
#   key_name   = "my-key"
#   public_key = tls_private_key.example.public_key_openssh
# }

# # Save the private key to a local file
# resource "local_file" "private_key" {
#   content  = tls_private_key.example.private_key_pem
#   filename = "${path.module}/my-key.pem"
#   file_permission = "0400"
# }

# resource "aws_instance" "web" {
#   ami                    = "ami-084568db4383264d4"  # Ubuntu us-east-1
#   instance_type          = "t2.micro"
#   key_name               = aws_key_pair.mykey.key_name  # Correct reference
#   associate_public_ip_address = true

#   tags = {
#     Name = "Jenkins-Ansible-EC2"
#   }
# }

# output "public_ip" {
#   value = aws_instance.web.public_ip
# }
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
  access_key = "ASIASIP4EGGBMOBMCL3G"
  secret_key = "9bDOakwuv1y5MK3/HhXAWjNpCQ+M4AhvkJRNpz+G"
  token = "IQoJb3JpZ2luX2VjEIv//////////wEaCXVzLXdlc3QtMiJHMEUCIQCUHYHSIm8O6Aed8ptwy0UZYMgGzA2+QCMI8+F1kq8oDgIgHCPLX023WoRlGArwecasU4RedDO6P4iXZ/1Urw5e/ZkqrwIIFBAAGgwxNTU2ODQ0NTA2OTAiDFjcdExRZMx5MWlB0iqMAmH00+JS9ovEHDq8JB8Ht4wl0mEks1UJGd2rad1c05L9keMOOFQdHWyoAO9GUJeAu2VvRobt+gZOvxmdueLLXoCCSIuxvKvGGJ1w86U3rEvqIuTB5oyVm+zvwgABNLFgKdAg39tbHwug4kj1x/TvXO4StLtQJzHG5b1W2hBbTF0C39LfN+jIXbUhJRRZ7zaWY5JilZjZ7yZ+w1sfzD1A4m1e+dqe0WpJD6gREXj+qdV48EVibvsu6BM+kq2DgBBkPgtspkc9NyDO9Xa/QVHQmbnf8yindlRhv5bkqaFS14fc7P/FUqyc3cNS5NCKJCrb+TFSNmy3rQm+2Qf/9pofFK0H2sDimrLmd700nK8w28jzvwY6nQH50tX+ULsmPpyhah4MRt3PrA77XCxYje6hg1YlI1CJLDCODdzHLDHgpOHjyKsmcyhAj5PjThIUGEBqAA3Hi3gcZWFnEWw5nWg/Fy2E5gVGGP82LaTI/UoC+OlhlSG+OLzZgg9A5mJT8mRnS1DvwmP84WAXFjDDN63ULWsQsZK4/kr+KFdfvsDnaWLydYTRbYqaUvQbYsbMIGQhLJ9W"
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