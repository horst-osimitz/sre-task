locals {
  account_id                 = data.aws_caller_identity.current.id
  vpc_id                     = "vpc-064c3eb0153d40a17"
  private_subnet_cidr_blocks = [for s in data.aws_subnet.private : s.cidr_block]
  private_subnet_ids         = data.aws_subnets.private.ids
  operator_ip                = "62.178.186.6/32"
}

data "aws_caller_identity" "current" {}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}
