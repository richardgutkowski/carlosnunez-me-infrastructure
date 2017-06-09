require 'yaml'
require 'rspec'

if not ENV['TARGET_ENVIRONMENT']
  raise 'TARGET_ENVIRONMENT not found in your environment; please define it.'
end

RSpec.configure do |config|
  config.before(:all) {
    terraform_plan_json_str = \
      `./terraform plan -state=no_state_for_testing -out=terraform.tfplan > /dev/null \
      [ -f terraform.plan ] && tfjson terraform.plan`
    if terraform_plan_json_str == ""
      raise "Mock Terraform plan was not generated."
    end
    $terraform_plan = JSON.parse(terraform_plan_json_str)
  }
  config.after(:all) {
    `rm terraform.tfplan`
  }
end
