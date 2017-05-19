data "aws_availability_zones" "available" {}

module "nat" {
  name                   = "electionleaflets-nat"
  source                 = "github.com/ashb/tf_aws_nat?ref=v0.9.3-pre1"
  instance_count         = 1
  instance_type          = "t2.nano"
  public_subnet_ids      = ["${aws_subnet.public-a.id}", "${aws_subnet.public-b.id}"]
  private_subnet_ids     = ["${aws_subnet.private-a.id}", "${aws_subnet.private-b.id}"]
  subnets_count          = "${length(data.aws_availability_zones.available.names)}"
  az_list                = ["${data.aws_availability_zones.available.names}"]
  vpc_security_group_ids = ["${aws_security_group.nat.id}"]
  aws_key_name           = "electionleaflets"
  awsnycast_deb_url      = "https://github.com/ashb/AWSnycast/releases/download/v0.1.3-pre1/awsnycast_0.1.3-pre1-debug0_amd64.deb"
}

resource "aws_security_group" "nat" {
  name   = "electionleaflets-nat"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${aws_vpc.main.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
