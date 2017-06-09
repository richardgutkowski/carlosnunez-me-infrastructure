#!/usr/bin/env ruby
require 'fileutils'
sh %{'[ -f terraform.tfplan ] && rm terraform.tfplan'}
sh %{'terraform plan -state=nil -out=terraform.tfplan > /dev/null'}
