#!/usr/bin/env ruby
require 'rake'
sh %{'rm -q terraform.tfplan'}
sh %{'terraform plan -state=nil -out=terraform.tfplan > /dev/null'}
