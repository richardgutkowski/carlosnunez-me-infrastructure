What is this?
=============

This will provision Carlos's working environment from scratch on AWS.

What's required?
================

* An AWS account key and secret. You can get that by signing up on aws.com, downloading the awscli (`pip install awscli`) and running `aws configure`.
* Docker >= v17.03
* docker-compose

NOTE: Terraform will use the AWS region, access and secret keys defined by the
environment variables AWS_REGION, AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
respectively. `rake` will let you know if they're missing. :)

How do I run this?
==================

1. Create `tfvar`s for your environments in `config/`. Refer to the example
Terraform configuration provided to see how this should be structured.
Naming format should be: `config/terraform.tfvars.<environment>`

2. Run `./deploy ${environment}`. This will create a local Jenkins CI that
will deploy your infrastructure through the pipeline defined by
`Jenkinsfile`.

NOTE: This will be slow the first time you run it, as Docker will need to build
dependent images. It should be significantly faster on subsequent runs.

I don't want full CI. How can I run this manually?
===================================================

If you want to do quick local tests, take a look at the "unit" step within
the `Jenkinsfile`.

Damn, son; why do you have so many commits?!
=============================================

1. I don't know how to code.
2. I commit on every save. Want to do the same? Check out my [.vimrc](https://github.com/carlosonunez/setup.git)
