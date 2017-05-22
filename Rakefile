require 'dotenv/tasks'
require 'rspec/core/rake_task'
require_relative 'lib/environments'
require_relative 'lib/terraform_helper'

task check_env_vars: :dotenv do
  required_env_vars_with_valid_values = {
    'TARGET_ENVIRONMENT' => get_supported_environments
  }
  required_env_vars_with_valid_values.each do |env_var, supported_env_var_values|
    require pp
    pp ENV
    raise "#{env_var} is not defined in your environment; please define it." if !ENV[env_var]
    raise "#{ENV[env_var]} is not a valid value for #{ENV[env_var]}" if !supported_env_var_values.contains? ENV[env_var]
  end
end

task :install_terraform_if_needed do
  terraform_version = `terraform version`
  if terraform_version == "" or terraform_version.contains? 'Your version of Terraform is out of date'
    install_latest_version_of_terraform!
  end
end

task unit: :dotenv do
  RSpec::Core::RakeTask.new(:rspec) do
    task.pattern = Dir.glob('spec/**/*_spec.rb')
    task.rspec_opts = '--format documentation'
  end
end

task :default => [ 'check_env_vars', 'install_terraform_if_needed', 'unit' ]
