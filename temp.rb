#!/usr/bin/env ruby
require 'rake'
%x('[ -f "terraform.tfplan" ] && rm terraform.tfplan')
%x('terraform plan -state=nil -out=terraform.tfplan > /dev/null')
