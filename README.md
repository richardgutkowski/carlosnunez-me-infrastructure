What is this?
=============

This will provision Carlos's working environment from scratch on AWS.

What's required?
================

* An AWS account key and secret. You can get that by signing up on aws.com, downloading the awscli (`pip install awscli`) and running `aws configure`.

How do I run this?
==================

1. Set your Ruby env vars in `config/application.yml`. An example is provided in `config/application.yml.example`.
2. Run `rake` to ensure that unit tests pass.
3. Run `rake deploy` to deploy the environment.
