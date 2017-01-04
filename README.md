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

7. Run `packer build -machine-readable -var-file=include/develop/packervars/coreos.json include/images/packer_configs/coreos.json | tee build.log` to build your CoreOS AMI. Its ID will be stored in `build.log` at the root of your repository.

> NOTE: This will create an EBS snapshot. This costs money.

8. Run `egrep "artifact,.*,string,AMIs.*" build.log | sed 's/.*created:\(.*\)/\1/g' | tr -d '\\n ' | grep $AWS_REGION | cut -f2 -d: | while read id; do echo "coreos_ami_id=\"${id}\"" >> include/develop/packervars/coreos.tf; done`. This will extract the AMI created for the region specified and move it to include/develop/image_ids/coreos.tf for use by Terraform.

> NOTE: Unfortunately, Packer does not have the ability to output the IDs created to a file natively.

9. Have a look at `include/develop/tfvars/coreos.tfvars` and edit the number of nodes you would like to provision and any other parameter you'd like to modify

10. Run `terraform plan -var-file=include/develop/env.tfvars -var-file=include/develop/tfvars/coreos.tfvars -var-file=include/develop/image_ids/coreos.tfvars` to plan your Terraform deployment. Ensure that it creates *n* instances as defined by `include/develop/tfvars/coreos.tfvars` as well as its requisite security groups and Route 53 CNAME RRs.
