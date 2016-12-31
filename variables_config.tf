variable "terraform_remote_state_key_name" {
  description = "The file name of the Terraform config located within s3."
}

variable "terraform_remote_state_bucket_name" {
  description = "The s3 bucket in which the Terraform state for this deployment is located."
}

variable "terraform_remote_state_region_name" {
  description = "The s3 region to use for locating this Terraform state."
  default = "us-east-1"
}
