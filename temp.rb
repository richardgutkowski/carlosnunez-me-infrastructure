#!/usr/bin/env ruby
require 'rake'
system('[ -f "terraform.tfplan" ] && rm terraform.tfplan')
system('terraform plan -state=nil -out=terraform.tfplan > /dev/null')
system('tfjson terraform.tfplan')

#---

system('[ -f "terraform2.tfplan" ] && rm terraform2.tfplan \
				./terraform plan -state=nil \
												 -out=terraform2.tfplan ; \
				tfjson terraform2.tfplan')
