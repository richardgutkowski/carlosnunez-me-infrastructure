require 'rake'
system('terraform plan -state=nil -out=terraform.tfplan > /dev/null')
str = system('tfjson terraform.tfplan')
system('rm terraform.tfplan')
