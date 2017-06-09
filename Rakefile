require 'colorize'
require 'dotenv/tasks'
require 'rspec/core/rake_task'
require_relative 'lib/environments'
require_relative 'lib/terraform_helper'

namespace :prerequisites do
  task :check_for_terraform_tfvars do
    if not File.exist? 'terraform.tfvars'
      raise "ERROR: Terraform variables not found. Did you pull them in from S3?".red
    end
  end

  task check_env_vars: :dotenv do
    required_rake_env_vars_with_valid_values = {
      'AWS_ACCESS_KEY_ID' => "CHECK_NOT_REQUIRED",
      'AWS_S3_TERRAFORM_TFVARS_BUCKET' => "CHECK_NOT_REQUIRED",
      'AWS_SECRET_ACCESS_KEY' => "CHECK_NOT_REQUIRED",
      'TARGET_ENVIRONMENT' => get_supported_environments
    }
    required_rake_env_vars_with_valid_values.each do |env_var, supported_env_var_values|
      raise "ERROR: #{env_var} is not defined in your environment; please define it." if !ENV[env_var].red
      if supported_env_var_values != "CHECK_NOT_REQUIRED" and !supported_env_var_values.include? ENV[env_var]
        if supported_env_var_values.nil?
          raise "ERROR: No supported environments found. (Check your bucket: #{ENV['AWS_S3_TERRAFORM_TFVARS_BUCKET']})"
        end
        raise "ERROR: #{ENV[env_var]} is not a valid value for #{ENV[env_var]}".red
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
      raise "ERROR: terraform-lint failed! Error: #{lint_error_message}".red
    end
  end
end

namespace :unit do
  RSpec::Core::RakeTask.new(:spec) do |task|
    task.rspec_opts = ['--color', '-f progress', '-r ./spec/spec_helper.rb']
    task.pattern = 'spec/**/*_spec.rb'
  end
end

task :prereqs => ['prerequisites:check_for_terraform_tfvars', \
                  'prerequisites:check_env_vars', \
                  'prerequisites:install_terraform_if_needed' ]

task :unit => [ 'prereqs',
                'static_analysis:lint',
                'unit:spec']

task :integration => [ ]

task :deploy => [ ]

task :default => [ 'unit',
                   'integration',
                   'deploy' ]
