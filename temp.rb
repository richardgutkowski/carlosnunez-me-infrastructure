#!/usr/bin/env ruby
require 'rake'
system('[ -f "terraform.tfplan" ] && rm terraform.tfplan')
system('terraform plan -state=nil -out=terraform.tfplan > /dev/null')
