require 'yaml'
require 'rspec'
require_relative 'config.rb'

if not ENV['TARGET_ENVIRONMENT']
  raise 'TARGET_ENVIRONMENT not found in your environment; please define it.'
end

RSpec.configure do |config|
  config_for_all_environments = load_config
  config.before(:example) {
    @config = config_for_all_environments[ENV['TARGET_ENVIRONMENT']]
  }
end
