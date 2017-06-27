require 'yaml'
require 'rspec'
require 'colorize'
Dir.glob('spec/lib/{initialisation,cleanup}/*.rb').each do |file|
  absolute_filepath = 
    File.expand_path(File.dirname(__FILE__)) + "/../#{file}"
  require_relative absolute_filepath
end

if not ENV['TARGET_ENVIRONMENT']
  raise 'TARGET_ENVIRONMENT not found in your environment; please define it.'
end

RSpec.configure do |config|
  config.fail_fast = true
  config.before(:suite) {
    begin
      $terraform_tfvars = initialise_global_terraform_tfvars!
      $terraform_plan = initialise_global_terraform_plan!
    rescue
      raise 'Something went wrong while initialising Terraform. See the errors \
above for more information.'
    ensure
      cleanup_terraform_residue!
    end
  }
  config.after(:suite) {
    cleanup_terraform_residue!
  }
end
