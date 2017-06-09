require 'rake'
system('terraform plan -state=nil -out=terraform.tfplan > /dev/null')
str = system('tfjson terraform.tfplan')
system('rm terraform.tfplan')

# ---

system('./terraform plan -state=dummy_state -out=${TARGET_ENVIRONMENT}_infra_fixture.tfplan > /dev/null')
terraform_plan_as_json_str = system('tfjson ./${TARGET_ENVIRONMENT}_infra_fixture.tfplan')
system('rm -rf ./dummy_state ${TARGET_ENVIRONMENT}_infra_fixture.tfplan')
