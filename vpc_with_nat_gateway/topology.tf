##--------- VPC
resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "my_vpc"
  }
}

## Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "Internet Gateway"
  }
}

##--------- Public Part
resource "aws_route_table" "routetable_public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "Public Routetable"
  }
}

resource "aws_route" "r" {
  route_table_id         = "${aws_route_table.routetable_public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet_gateway.id}"
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.public_subnet_cidr}"
  availability_zone = "${data.aws_region.current.name}a"

  tags {
    Name = "Public Subnet"
  }
}

resource "aws_route_table_association" "public_subnet_a" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.routetable_public.id}"
}

##------- Nat Gateway

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public_subnet.id}"
}

resource "aws_route" "nat_route" {
  route_table_id         = "${aws_route_table.routetable_nat.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
}

##-------- Private Subnet

resource "aws_route_table" "routetable_nat" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "Nat Routetable"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.private_subnet_cidr}"
  availability_zone = "${data.aws_region.current.name}a"

  tags {
    Name = "Private Subnet"
  }
}

resource "aws_route_table_association" "private_subnet" {
  subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.routetable_nat.id}"
}

output "private_subnet_id" {
  value = "${aws_subnet.private_subnet.id}"
}
