require 'yaml'
require 'rspec'

if not ENV['TARGET_ENVIRONMENT']
  raise 'TARGET_ENVIRONMENT not found in your environment; please define it.'
end

RSpec.configure do |config|
  config.before(:all) {
    tfjson_location = [ ENV['GOPATH'], 'bin', 'tfjson' ].join('/')
    if not File.exist? tfjson_location
      raise "tfjson not found at #{tfjson_location}. Rakefile should have installed it..."
    end
		terraform_plan_as_json_str = `#{ENV['PWD']}/old_terraform plan \
-state=discarded_state_not_required_for_unit_tests \
-out=terraform_fixture.tfplan > /dev/null`
    if terraform_plan_as_json_str.nil? or terraform_plan_as_json_str.empty?
      raise "Mock Terraform plan was not generated."
    end
    $terraform_plan = JSON.parse(terraform_plan_as_json_str)
  }
  config.after(:all) {
    [ './dummy_state', './terraform_fixture.tfplan' ].each do |file|
      if File.exist? file
        `rm #{file}`
      end
    end
  }
end
