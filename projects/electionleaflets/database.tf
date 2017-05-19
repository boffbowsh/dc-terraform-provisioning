resource "random_id" "db_super_password" {
  byte_length = 40
}

resource "aws_db_instance" "default" {
  allocated_storage      = 5
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "9.6.2"
  instance_class         = "db.t2.micro"
  name                   = "postgres"
  username               = "postgres"
  password               = "${random_id.db_super_password.b64}"
  db_subnet_group_name   = "${aws_db_subnet_group.default.id}"
  parameter_group_name   = "default.postgres9.6"
  publicly_accessible    = true
  vpc_security_group_ids = ["${aws_security_group.rds_allow_all.id}"]

  tags {
    Name = "electionleaflets"
  }
}

resource "aws_security_group" "rds_allow_all" {
  name   = "rds_allow_all"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${aws_subnet.public-a.id}", "${aws_subnet.public-b.id}"]
}

provider "postgresql" {
  host            = "${aws_db_instance.default.address}"
  username        = "${aws_db_instance.default.username}"
  password        = "${random_id.db_super_password.b64}"
  sslmode         = "require"
  connect_timeout = 15
}

resource "random_id" "db_staging_password" {
  byte_length = 40
}

resource "postgresql_role" "electionleaflets_staging" {
  name     = "electionleaflets_staging"
  login    = true
  password = "${random_id.db_staging_password.b64}"
}

resource "postgresql_database" "electionleaflets_staging" {
  name  = "electionleaflets_staging"
  owner = "${postgresql_role.electionleaflets_staging.name}"
}

resource "random_id" "db_production_password" {
  byte_length = 40
}

resource "postgresql_role" "electionleaflets_production" {
  name     = "electionleaflets_production"
  login    = true
  password = "${random_id.db_production_password.b64}"
}

resource "postgresql_database" "electionleaflets_production" {
  name  = "electionleaflets_production"
  owner = "${postgresql_role.electionleaflets_staging.name}"
}
