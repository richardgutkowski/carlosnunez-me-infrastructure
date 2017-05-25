require 'yaml'
require 'rspec'
require_relative '../lib/config'

if not ENV['TARGET_ENVIRONMENT']
  raise 'TARGET_ENVIRONMENT not found in your environment; please define it.'
end

RSpec.configure do |config|
  config_for_all_environments = load_config
  config.before(:example) {
    @infrastructure_config = config_for_all_environments[ENV['TARGET_ENVIRONMENT']]
  }
end
