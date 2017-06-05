What is this?
=============

This will provision Carlos's working environment from scratch on AWS.

What's required?
================

* An AWS account key and secret. You can get that by signing up on aws.com, downloading the awscli (`pip install awscli`) and running `aws configure`.

NOTE: Terraform will use the AWS region, access and secret keys defined by the
environment variables AWS_REGION, AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
respectively. `rake` will let you know if they're missing. :)

How do I run this?
==================

1. Set your Ruby env vars in `config/application.yml`. An example is provided in `config/application.yml.example`.
2. Run `rake` to ensure that unit tests pass.
3. Run `rake deploy` to deploy the environment.
