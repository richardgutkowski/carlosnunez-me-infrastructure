require 'yaml'
require 'rspec'

if not ENV['TARGET_ENVIRONMENT']
  raise 'TARGET_ENVIRONMENT not found in your environment; please define it.'
end

RSpec.configure do |config|
  config.before(:all) {
    @terraform_plan = `terraform plan 2>&1`
  }
end
