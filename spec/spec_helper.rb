require 'yaml'
require 'rspec'
require 'colorize'

if not ENV['TARGET_ENVIRONMENT']
  raise 'TARGET_ENVIRONMENT not found in your environment; please define it.'
end

RSpec.configure do |config|
  config.before(:suite) {
  }
  config.after(:suite) {
    [ './dummy_state', './terraform_fixture.tfplan' ].each do |file|
      if File.exist? file
        `rm #{file}`
      end
    end
  }
end
