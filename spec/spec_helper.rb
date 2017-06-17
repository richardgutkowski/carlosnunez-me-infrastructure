require 'yaml'
require 'rspec'

if not ENV['TARGET_ENVIRONMENT']
  raise 'TARGET_ENVIRONMENT not found in your environment; please define it.'
end

RSpec.configure do |config|
  config.before(:all) {
		system('\$PWD/old_terraform plan -state=discarded_state_not_required_for_unit_tests \
-out=terraform_fixture.tfplan > /dev/null')
		terraform_plan_as_json_str = system('tfjson ./terraform_fixture.tfplan')
    if terraform_plan_as_json_str.empty?
      raise "Mock Terraform plan was not generated."
    end
    $terraform_plan = JSON.parse(terraform_plan_json_str)
  }
  config.after(:all) {
    [ './dummy_state', './terraform_fixture.tfplan' ].each do |file|
      `rm #{file}`
    end
  }
end
