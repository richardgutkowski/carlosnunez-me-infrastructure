#!/usr/bin/env ruby
system('rm terraform.tfplan')
system('./terraform plan -state=no_state_for_testing -out=terraform.tfplan')
