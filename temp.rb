#!/usr/bin/env ruby
exec('rm terraform.tfplan')
exec('./terraform plan -state=no_state_for_testing -out=terraform.tfplan')
