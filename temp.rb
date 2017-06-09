#!/usr/bin/env ruby
system('terraform plan -state=no_state_for_testing -out=terraform.tfplan')
