require 'rake'
puts 'attempt 1'
system('terraform plan -state=nil -out=terraform.tfplan > /dev/null')
str = system('tfjson terraform.tfplan')
system('rm terraform.tfplan')

# ---
puts 'attempt 2'
system('./terraform plan -state=dummy_state -out=terraform.tfplan > /dev/null')
terraform_plan_as_json_str = system('tfjson ./terraform.tfplan')
system('rm -rf ./dummy_state terraform.tfplan')
