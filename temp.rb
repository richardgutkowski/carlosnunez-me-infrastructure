#!/usr/bin/env ruby
system('terraform plan -state=no_state_for_testing -out=terraform.tfplan > /dev/null')
exec('terraform plan -state=nil -out=terraform2.tfplan > /dev/null')
