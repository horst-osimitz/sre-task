# Generate a new RSA key pair
resource "tls_private_key" "ec2_webserver" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an EC2 key pair using the public key
resource "aws_key_pair" "ec2_webserver" {
  key_name   = "ec2-key-webserver"
  public_key = tls_private_key.ec2_webserver.public_key_openssh
}

# Store the private key in AWS Secrets Manager
resource "aws_secretsmanager_secret" "private_key_webserver" {
  name        = "ec2/webserver/private-key"
  description = "Private key for Webserver EC2 key pair"
}

resource "aws_secretsmanager_secret_version" "private_key_version_webserver" {
  secret_id     = aws_secretsmanager_secret.private_key_webserver.id
  secret_string = tls_private_key.ec2_webserver.private_key_pem
}

# Store the public key in AWS Secrets Manager (optional)
resource "aws_secretsmanager_secret" "public_key_webserver" {
  name        = "ec2/webserver/public-key"
  description = "Public key for Webserver EC2 key pair"
}

resource "aws_secretsmanager_secret_version" "public_key_version_webserver" {
  secret_id     = aws_secretsmanager_secret.public_key_webserver.id
  secret_string = tls_private_key.ec2_webserver.public_key_openssh
}

