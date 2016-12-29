data "terraform_remote_state" "tfstate" {
  backend = "s3"
  config {
    bucket = "${var.terraform_config_bucket_name}"
    key = "${var.terraform_config_key_name}"
    region = "${var.terraform_config_region_name}"
  }
}
