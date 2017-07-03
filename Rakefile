require 'colorize'
require 'dotenv/tasks'
require 'rspec/core/rake_task'
require_relative 'lib/environments'
require_relative 'lib/terraform_helper'

@REQUIRED_ENV_VARS = {
  'AWS_ACCESS_KEY_ID'=> {
    :description => "The access key for your AWS account. This is usually set \
up for you when you install awscli.",
    :supported_values => :anything
  },
  'AWS_S3_TERRAFORM_TFVARS_BUCKET'=> {
    :description => "The S3 bucket in which your Terraform .tfvar files are located.",
    :supported_values => :anything
  },
  'AWS_SECRET_ACCESS_KEY'=> {
    :description => "The secret key for your AWS account. This is usually set up \
for you when you install awscli.",
    :supported_values => :anything
  },
  'GOPATH'=> {
    :description => "The path to your Golang binaries and libraries. This is \
usually set up for you when you install Golang.",
    :supported_values => :anything
  },
  'TARGET_ENVIRONMENT'=> {
    :description => "The environment to which you are deploying. This determines \
the S3 key from which your tfvars are sourced.",
    :supported_values => get_supported_environments
  },
  'AWS_REGION'=> {
    :description => "The AWS region to which your infrastructure will be deployed. 
This is usually set up for you when you install awscli.",
    :supported_values => :anything
  }
}

@OPTIONAL_ENV_VARS = {
  'SKIP_TERRAFORM_UPDATE' => false
}

@REQUIRED_BINARY_VERSIONS = {
  :golang => 'go1.8',
  :terraform_for_tfjson => '0.8.8',
  :terraform => '0.9.8'
}

task :print_help do
  all_env_vars = @REQUIRED_ENV_VARS.merge(@OPTIONAL_ENV_VARS)
  print "USAGE: ".green
  puts "bundle exec rake [unit, test, deploy]"
  puts "Deploys this infrastructure onto the cloud or hardware of your choice.\n\n"
 
  puts "Supported environment variables:"
  all_env_vars.each do |env_var, env_var_properties|
    print "#{env_var}: ".yellow
    print "#{env_var_properties[:description]}"
    if not env_var_properties[:supported_values] != :anything
      print "Must be one of these: [#{env_var_properties[:supported_values]}]"
    end
    print "\n"
  end
end


namespace :prerequisites do
  task :check_for_golang do
    required_version_of_golang = @REQUIRED_BINARY_VERSIONS[:golang]
    matching_golang_version_found = `go version | grep -- #{required_version_of_golang}`
    if matching_golang_version_found.empty?
      raise "ERROR: Go is not installed. You'll need to install Golang to continue.".red
    end
  end

  task :check_for_terraform_tfvars do
    if not File.exist? 'terraform.tfvars'
      raise "ERROR: Terraform variables not found. Did you pull them in from S3?".red
    end
  end

  task process_env_vars: :dotenv do
    @options = {}
    @REQUIRED_ENV_VARS.each do |env_var, env_var_properties|
      actual_env_var_value = ENV[env_var]
      if not actual_env_var_value or actual_env_var_value.empty?
        raise "ERROR: Required environment variable not found: #{env_var}".red
        Rake::Task['print_help'].execute
      end
      supported_env_var_values = env_var_properties[:supported_values]
      if supported_env_var_values != :anything and
        supported_env_var_values.include? actual_env_var_value
        raise "ERROR: #{actual_env_var_value} is not supported. \
Supported values are: #{supported_env_var_values}".red
      end
      @options[env_var.downcase.to_sym] = actual_env_var_value
    end

    @OPTIONAL_ENV_VARS.each do |env_var, _|
      @options[env_var.downcase.to_sym] = actual_env_var_value
    end
  end

  task :install_tfjson_if_needed do
    result=`which tfjson > /dev/null || { \
echo "INFO: Installing tfjson" ; \
go get github.com/palantir/tfjson 2>/dev/null; }; echo $?`
    raise "ERROR: tfjson was not installed.".red if result.to_i != 0
  end
  task :download_latest_version_of_terraform_if_needed do
    terraform_version = `#{ENV['PWD']}/terraform version 2>/dev/null`
    if terraform_version == ""
      if @options[:skip_terraform_update] == false
        terraform_version.include? 'Your version of Terraform is out of date'
        puts "Terraform not found or out of date. Updating.".yellow
        `rm ./terraform`
        install_latest_version_of_terraform_into_working_directory!
      end
    end
  end
  task :download_tfjson_supported_terraform_if_needed do
    old_terraform_version = `#{ENV['PWD']}/old_terraform version 2>/dev/null | \
 grep #{TFJSON_SUPPORTED_TERRAFORM_VERSION}`
    if old_terraform_version.empty?
      puts "You don't have Terraform version #{TFJSON_SUPPORTED_TERRAFORM_VERSION} installed. \
This is required by tfjson for unit testing. We're installing this now.".yellow
      install_specific_version_of_terraform_into_working_directory! \
        version:TFJSON_SUPPORTED_TERRAFORM_VERSION
    end
  end
end

namespace :static_analysis do
  task :lint do
    print "INFO: Linting Terraform configurations...".yellow
    lint_successful, lint_error_message = lint_terraform_configurations_in_this_directory
    if !lint_successful
      print "failed!\n".red
      raise "ERROR: terraform-lint failed! Error: #{lint_error_message}".red
    end
    print "done!\n".green
  end
end

namespace :unit do
  RSpec::Core::RakeTask.new(:spec) do |task|
    task.rspec_opts = ['--color', '-f progress', '-r ./spec/spec_helper.rb']
    task.pattern = 'spec/**/*_spec.rb'
  end
end

task :prereqs => ['prerequisites:check_for_golang', \
                  'prerequisites:check_for_terraform_tfvars', \
                  'prerequisites:process_env_vars', \
                  'prerequisites:download_latest_version_of_terraform_if_needed', \
                  'prerequisites:download_tfjson_supported_terraform_if_needed', \
                  'prerequisites:install_tfjson_if_needed' ]

task :unit => [ 'prereqs',
                'static_analysis:lint',
                'unit:spec']

task :integration => [ ]

task :deploy => [ ]

task :default => [ 'unit', 'integration' ]

task :help => [ 'print_help' ]
