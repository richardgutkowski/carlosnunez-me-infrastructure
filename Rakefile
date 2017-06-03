require 'dotenv/tasks'
require 'rspec/core/rake_task'
require_relative 'lib/environments'
require_relative 'lib/terraform_helper'

namespace :prerequisites do
  task check_env_vars: :dotenv do
    required_env_vars_with_valid_values = {
      'TARGET_ENVIRONMENT' => get_supported_environments,
      'AWS_ACCESS_KEY_ID' => "CHECK_NOT_REQUIRED",
      'AWS_SECRET_ACCESS_KEY' => "CHECK_NOT_REQUIRED"
    }
    required_env_vars_with_valid_values.each do |env_var, supported_env_var_values|
      raise "#{env_var} is not defined in your environment; please define it." if !ENV[env_var]
      if supported_env_var_values != "CHECK_NOT_REQUIRED" and !supported_env_var_values.include? ENV[env_var]
        raise "#{ENV[env_var]} is not a valid value for #{ENV[env_var]}"
      end
    end
  end
  task :install_terraform_if_needed do
    terraform_version = `\$PWD/terraform version 2>/dev/null`
    if terraform_version == "" or terraform_version.include? 'Your version of Terraform is out of date'
      puts "Terraform not found or out of date. Updating."
      install_latest_version_of_terraform_into_working_directory!
    end
  end
end

namespace :static_analysis do
  task :lint do
    lint_successful, lint_error_message = lint_terraform_configurations_in_this_directory
    if !lint_successful
      raise "terraform-lint failed! Error: #{lint_error_message}"
    end
  end
end

namespace :unit do
  RSpec::Core::RakeTask.new(:spec) do |task|
    task.rspec_opts = ['--color', '-f progress', '-r ./spec/spec_helper.rb']
    task.pattern = 'spec/**/*_spec.rb'
  end
end

task :default => [ 'prerequisites:check_env_vars', \
                   'prerequisites:install_terraform_if_needed', \
                   'static_analysis:lint', \
                   'unit:spec' ]
