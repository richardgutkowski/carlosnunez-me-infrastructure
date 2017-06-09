#!/usr/bin/env ruby
require 'rake'
sh %{'[ -f terraform.tfplan ] && rm terraform.tfplan'}
sh %{'terraform plan -state=nil -out=terraform.tfplan > /dev/null'}
