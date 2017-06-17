require 'yaml'
require 'rspec'

if not ENV['TARGET_ENVIRONMENT']
  raise 'TARGET_ENVIRONMENT not found in your environment; please define it.'
end

RSpec.configure do |config|
  config.before(:all) {
    tfjson_location = [ ENV['GOPATH'], 'bin', 'tfjson' ].join('/')
    if not File.exist? tfjson_location
      raise "tfjson not found. Rakefile should have installed it..."
    end
		system("#{ENV['PWD']}/old_terraform plan -state=discarded_state_not_required_for_unit_tests \
-out=terraform_fixture.tfplan > /dev/null")
    terraform_plan_json_serialized = `#{tfjson_location} ./terraform_fixture.tfplan`
    puts "Got: #{terraform_plan_json_serialized}"
    if terraform_plan_json_serialized.nil? or terraform_plan_json_serialized.empty?
      raise "Mock Terraform plan was not generated."
    end
    $terraform_plan = JSON.parse(terraform_plan_json_str)
  }
  config.after(:all) {
    [ './dummy_state', './terraform_fixture.tfplan' ].each do |file|
      if File.exist? file
        `rm #{file}`
      end
    end
  }
end
