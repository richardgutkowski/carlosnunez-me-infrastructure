_ = system('./terraform plan -state=no_state_for_testing \
                                      -out=terraform.tfplan > /dev/null')
terraform_plan_json_str = system('tfjson ./terraform.tfplan')
