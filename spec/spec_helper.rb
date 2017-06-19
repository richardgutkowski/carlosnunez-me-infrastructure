require 'yaml'
require 'rspec'
require 'colorize'

if not ENV['TARGET_ENVIRONMENT']
  raise 'TARGET_ENVIRONMENT not found in your environment; please define it.'
end

RSpec.configure do |config|
  config.before(:suite) {
    tfjson_location = [ ENV['GOPATH'], 'bin', 'tfjson' ].join('/')
    if not File.exist? tfjson_location
      raise "tfjson not found. Rakefile should have installed it..."
    end

    print "INFO: Generating terraform plan now. This might take a few minutes...".yellow
		system("#{ENV['PWD']}/old_terraform plan -state=discarded_state_not_required_for_unit_tests \
-out=terraform_fixture.tfplan > /dev/null")
    print "done!\n".green

    terraform_plan_json_serialized = `#{tfjson_location} ./terraform_fixture.tfplan`
    if terraform_plan_json_serialized.nil? or terraform_plan_json_serialized.empty?
      raise "Mock Terraform plan was not generated."
    end
    $terraform_plan = JSON.parse(terraform_plan_json_serialized)

    $terraform_tfvars = {}
    File.open("#{ENV['PWD']}/terraform.tfvars",'r').map do |line|
      tfvar_key, tfvar_value = line.split('=').map do |item|
        item.sub('"','').gsub("\n",'').gsub(' ','').gsub('"','')
      end
      $terraform_tfvars[tfvar_key] = tfvar_value
    end
  }
  config.after(:suite) {
    [ './dummy_state', './terraform_fixture.tfplan' ].each do |file|
      if File.exist? file
        `rm #{file}`
      end
    end
  }
end
