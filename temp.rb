#!/usr/bin/env ruby
_ = system('terraform plan -state=no_state_for_testing -out=terraform.tfplan')
