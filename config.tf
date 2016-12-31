data "terraform_remote_state" "tfstate" {
  backend = "s3"
  config {
    bucket = "${var.terraform_remote_state_bucket_name}"
    region = "${var.terraform_remote_state_region_name}"
    key = "${var.terraform_remote_state_key_name}"
  }
}
