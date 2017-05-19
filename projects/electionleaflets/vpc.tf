resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public-a" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.1.0.0/25"
  availability_zone       = "${data.aws_region.current.name}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "electionleaflets-public-a"
  }
}

resource "aws_route_table_association" "public-a" {
  subnet_id      = "${aws_subnet.public-a.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "private-a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "10.1.0.128/25"
  availability_zone = "${data.aws_region.current.name}a"

  tags = {
    Name = "electionleaflets-private-a"
  }
}

resource "aws_route_table_association" "private-a" {
  subnet_id      = "${aws_subnet.private-a.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_subnet" "public-b" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.1.2.0/25"
  availability_zone       = "${data.aws_region.current.name}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "electionleaflets-public-b"
  }
}

resource "aws_route_table_association" "public-b" {
  subnet_id      = "${aws_subnet.public-b.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "private-b" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "10.1.2.128/25"
  availability_zone = "${data.aws_region.current.name}b"

  tags = {
    Name = "electionleaflets-private-b"
  }
}

resource "aws_route_table_association" "private-b" {
  subnet_id      = "${aws_subnet.private-b.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${module.nat.instance_ids[0]}"
  }
}

resource "aws_vpc_endpoint" "private-s3" {
  vpc_id       = "${aws_vpc.main.id}"
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  vpc_endpoint_id = "${aws_vpc_endpoint.private-s3.id}"
  route_table_id  = "${aws_route_table.private.id}"
}
