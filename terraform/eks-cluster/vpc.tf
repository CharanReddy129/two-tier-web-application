data "aws_availability_zones" "zones" {
  state = "available"
}

resource "aws_vpc" "demo" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.demo.id
  availability_zone       = data.aws_availability_zones.zones.names[0]
  cidr_block              = cidrsubnet(var.cidr_block, 8, 10)
  map_public_ip_on_launch = true
  tags                    = var.tags
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.demo.id
  availability_zone       = data.aws_availability_zones.zones.names[1]
  cidr_block              = cidrsubnet(var.cidr_block, 8, 20)
  map_public_ip_on_launch = true
  tags                    = var.tags
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id                  = aws_vpc.demo.id
  availability_zone       = data.aws_availability_zones.zones.names[0]
  cidr_block              = cidrsubnet(var.cidr_block, 8, 100)
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, local.additional_tags)
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id                  = aws_vpc.demo.id
  availability_zone       = data.aws_availability_zones.zones.names[1]
  cidr_block              = cidrsubnet(var.cidr_block, 8, 110)
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, local.additional_tags)
}


resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.demo.id
  tags   = var.tags
}

resource "aws_eip" "eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.gateway]
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet-1.id
  depends_on    = [aws_eip.eip]
  tags          = var.tags
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.demo.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
  tags = var.tags
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.demo.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}


resource "aws_route_table_association" "public-1" {
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public-subnet-1.id
}

resource "aws_route_table_association" "public-2" {
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public-subnet-2.id
}

resource "aws_route_table_association" "private-1" {
  route_table_id = aws_route_table.private_route.id
  subnet_id      = aws_subnet.private-subnet-1.id
}

resource "aws_route_table_association" "private-2" {
  route_table_id = aws_route_table.private_route.id
  subnet_id      = aws_subnet.private-subnet-2.id
}