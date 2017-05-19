resource "aws_s3_bucket" "zappa_and_secrets" {
  bucket = "zappa-electionleaflets-${data.aws_region.current.name}"
  acl    = "private"
  region = "eu-west-1"
}

resource "aws_s3_bucket_object" "staging_secrets" {
  bucket = "${aws_s3_bucket.zappa_and_secrets.bucket}"
  key    = "staging_secrets.json"

  content = <<JSON
{
  "DATABASE_HOST": "${aws_db_instance.default.address}",
  "DATABASE_NAME": "${postgresql_database.electionleaflets_staging.name}",
  "DATABASE_USER": "${postgresql_role.electionleaflets_staging.name}",
  "DATABASE_PASS": "${random_id.db_staging_password.b64}"
}
  JSON
}

resource "aws_s3_bucket_object" "production_secrets" {
  bucket = "${aws_s3_bucket.zappa_and_secrets.bucket}"
  key    = "production_secrets.json"

  content = <<JSON
{
  "DATABASE_HOST": "${aws_db_instance.default.address}",
  "DATABASE_NAME": "${postgresql_database.electionleaflets_production.name}",
  "DATABASE_USER": "${postgresql_role.electionleaflets_production.name}",
  "DATABASE_PASS": "${random_id.db_production_password.b64}"
}
  JSON
}
