> NOTE: This README is a work-in-progress and is incomplete.

Errata
======
1. VPC and subnet creation is still manual. This will be corrected.

What this does
==============
This will provision a n-node CoreOS cluster running Docker Swarm.

How to run it
==============

> You will need to install Terraform and Packer first. If you'd like to do this automatically, have a look at my Bash scripts over at https://github.com/carlosonunez/setup.

1. Obtain an AWS access ID and secret key from AWS IAM and set them to `AWS_ACCESS_ID` and `AWS_SECRET_ACCESS_KEY`, respectively. You will also need to set your `AWS_REGION`.

2. Create a VPC in your EC2 account and add at least one subnet to it.

3. Create a security group to allow inbound port 22 access to your instances from your workstation's IP address.

4. Search for "_subnet_id" and "default_ssh_access_sg_id" in this repository. Replace their values with the ID for your subnet and the security group that you created, respectively.

5. This repository is configured to save its `tfstate`s in the "cnunez-infrastructure-data" S3 bucket. This is set up in `include/develop/tfvars/config.tfvars`. Change this to the S3 bucket of your choice.

> NOTE: All commands below will need to be run from the root of this repository.

6. Run `packer validate -var-file=include/develop/packervars/coreos.json include/images/packer_configs/coreos.json`. This will validate that the Packer configuration for your new CoreOS image is ready to go.

7. Run `packer build -machine-readable -var-file=include/develop/packervars/coreos.json include/images/packer_configs/coreos.json` to build your CoreOS AMI. Its ID will be stored in `build.log` at the root of your repository.

> NOTE: This will create an EBS snapshot. This costs money.

8.  
