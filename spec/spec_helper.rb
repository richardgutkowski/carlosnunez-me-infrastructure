require 'yaml'
require 'rspec'
require_relative '../lib/config'

if not ENV['TARGET_ENVIRONMENT']
  raise 'TARGET_ENVIRONMENT not found in your environment; please define it.'
end

RSpec.configure do |config|
  config.before(:all) {
    $terraform_stdout = `terraform plan`
  }
end
