require 'rspec/core/rake_task'
require_relative 'lib/environments'

namespace :check_env_vars do
  required_env_vars_with_valid_values = {
    'TARGET_ENVIRONMENT' => get_supported_environments
  }
  required_env_vars_with_valid_values.each do |env_var, supported_env_var_values|
    raise "#{env_var} is not defined in your environment; please define it." if !ENV[env_var]
    raise "#{ENV[env_var]} is not a valid value for #{ENV[env_var]}" if !supported_env_var_values.contains? ENV[env_var]
  end
end

namespace :install_terraform_if_needed do
  if `which terraform` == ""
    install_latest_version_of_terraform
  end
end

namespace :unit do
  RSpec::Core::RakeTask.new(:rspec) do
    task.pattern = Dir.glob('spec/**/*_spec.rb')
    task.rspec_opts = '--format documentation'
  end
end

task :default => [ 'check_env_vars', 'install_terraform_if_needed', 'unit:rspec' ]
