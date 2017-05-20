What is this?
=============

This will provision Carlos's working environment from scratch on AWS.

What's required?
================

* An AWS account key and secret. You can get that by signing up on aws.com, downloading the awscli (`pip install awscli`) and running `aws configure`.
* Terraform. (Windows: `choco install terraform`, OS X: `brew install terraform`, Linux: `curl -L https://releases.hashicorp.com/terraform 2>/dev/null | grep 'a href="/terraform' | head -n 1 | sed 's/.*"\(.*\)".*/\1/' | while read path; do curl -L https://releases.hashicorp.com$path 2>&1 | grep 'data-os="linux" data-arch="amd64"' | sed 's/.*href="\(.*\)".*/\1/' | while read latest_linux_release_path; do wget -O terraform.zip https://releases.hashicorp.com$latest_linux_release_path; done; done`)

How do I run this?
==================

1. Set your Ruby env vars in `config/application.yml`. An example is provided in `config/application.yml.example`.
2. Run `rake` to ensure that unit tests pass.
3. Run `rake deploy` to deploy the environment.
