#!/usr/bin/env ruby
exec('./terraform plan -state=no_state_for_testing -out=terraform.tfplan > /dev/null')
