module "ec2_instance_webserver" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "webserver"

  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ec2_webserver.key_name
  ami                    = "ami-0ef32de3e8ab0640e" # Debian 12 (20250316-2053)
  monitoring             = true
  vpc_security_group_ids = [module.ec2_sg_webserver.security_group_id]
  subnet_id              = local.private_subnet_ids[0]

  user_data                   = file("userdata/webserver-userdata.sh")
  user_data_replace_on_change = true

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Type        = "webserver"
  }
}
