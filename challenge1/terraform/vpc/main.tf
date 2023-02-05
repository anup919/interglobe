data "aws_availability_zones" "available" {}




resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}



resource "aws_subnet" "public_subnet" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.main.id
  cidr_block = "20.0.${10+count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "var.public_subnet_name${0 + count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.main.id
  cidr_block = "20.0.${20+count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "var.private_subnet_name${0 + count.index}"
  }
}

resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = var.igw_name
 }
}



resource "aws_route_table" "route_table2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


  tags = {
    Name = var.route_name2
  }
}

resource "aws_route_table_association" "a" {
  count = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.route_table2.id
}


output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
 value = aws_subnet.public_subnet[*].id
}

output "private_subnet_id" {
  value =  aws_subnet.private_subnet[*].id 
}

output "igw" {
  value = aws_internet_gateway.gw.id
}
output "az" {
  value = data.aws_availability_zones.available 
}
