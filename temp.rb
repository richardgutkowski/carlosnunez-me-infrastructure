#!/usr/bin/env ruby
puts `./terraform plan -state=no_state_for_testing -out=terraform.tfplan`
