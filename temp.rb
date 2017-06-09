#!/usr/bin/env ruby
require 'rake'
system('terraform plan -state=nil -out=terraform.tfplan > /dev/null')
system('tfjson terraform.tfplan')
system('rm terraform.tfplan')
