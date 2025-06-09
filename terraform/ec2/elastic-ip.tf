# Allocate a new Elastic IP in the default VPC
resource "aws_eip" "ec2_instance_webserver" {
  instance = module.ec2_instance_webserver.id
}
