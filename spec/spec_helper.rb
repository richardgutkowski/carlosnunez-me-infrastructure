require 'yaml'
require 'rspec'
require 'colorize'
Dir.glob('spec/lib/{initialisation,cleanup}/*.rb').each do |file|
  require file
end

if not ENV['TARGET_ENVIRONMENT']
  raise 'TARGET_ENVIRONMENT not found in your environment; please define it.'
end

RSpec.configure do |config|
  config.before(:suite) {
    initialise_global_terraform_tfvars!
    initialise_global_terraform_plan!
    initialise_global_coreos_release_data!
  }
  config.after(:suite) {
    cleanup_terraform_residue!
  }
end
