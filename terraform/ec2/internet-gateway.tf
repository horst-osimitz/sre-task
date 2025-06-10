resource "aws_internet_gateway" "igw" {
  vpc_id = local.vpc_id
}

# resource "aws_internet_gateway_attachment" "igw" {
#   internet_gateway_id = aws_internet_gateway.igw.id
#   vpc_id              = local.vpc_id
# }

data "aws_vpc" "selected" {
  id = local.vpc_id
}

resource "aws_default_route_table" "igw" {
  default_route_table_id = local.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
