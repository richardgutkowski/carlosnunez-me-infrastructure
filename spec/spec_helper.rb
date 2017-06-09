require 'yaml'
require 'rspec'

if not ENV['TARGET_ENVIRONMENT']
  raise 'TARGET_ENVIRONMENT not found in your environment; please define it.'
end

RSpec.configure do |config|
  config.before(:all) {
		system('./terraform plan -state=dummy_state -out=${TARGET_ENVIRONMENT}_infra_fixture.tfplan > /dev/null')
		terraform_plan_as_json_str = system('tfjson ./${TARGET_ENVIRONMENT}_infra_fixture.tfplan')
		system('rm -rf ./dummy_state ${TARGET_ENVIRONMENT}_infra_fixture.tfplan')
    if terraform_plan_as_json_str == ""
      raise "Mock Terraform plan was not generated."
    end
    $terraform_plan = JSON.parse(terraform_plan_json_str)
  }
  config.after(:all) {
    `rm terraform.tfplan`
  }
end
