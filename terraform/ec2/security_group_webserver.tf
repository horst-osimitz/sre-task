module "ec2_sg_webserver" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ec2-webserver-sg"
  description = "Security group for Webserver"
  vpc_id      = local.vpc_id

  # ingress_cidr_blocks = local.private_subnet_cidr_blocks
  ingress_rules = ["https-443-tcp", "http-80-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allow SSH connections from MacBookPro4OH"
      cidr_blocks = join(",", concat(local.private_subnet_cidr_blocks, [local.operator_ip, local.mobile_ip]))
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow http connection from MacBookPro4OH"
      # cidr_blocks = join(",", concat(local.private_subnet_cidr_blocks, [local.operator_ip, "${aws_eip.ec2_instance_webserver.public_ip}/32", "0.0.0.0/0"]))
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow https connection from MacBookPro4OH"
      cidr_blocks = join(",", ["${local.operator_ip}", "${local.mobile_ip}"])
    },
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
      # cidr_blocks = "${module.ec2_instance_webserver.public_ip}/32"
    },
  ]
}
