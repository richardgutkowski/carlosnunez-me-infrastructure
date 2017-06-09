require 'yaml'
require 'rspec'
require 'open3'

if not ENV['TARGET_ENVIRONMENT']
  raise 'TARGET_ENVIRONMENT not found in your environment; please define it.'
end

RSpec.configure do |config|
  config.before(:all) {
    $terraform_plan, $terraform_plan_stdout, _ = 
      Open3.capture("terraform plan -state=nil_state_for_testing")
  }
end
