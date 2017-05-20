require 'rspec/core/rake_task'

namespace :check_env_vars do
  required_env_vars_with_valid_values = {
    :TARGET_ENVIRONMENT => [ 'development', 'production' ]
  }
  required_env_vars_with_valid_values.each do |env_var, supported_env_var_values|
    raise "#{env_var} is not defined in your environment; please define it." if !ENV[env_var]
    raise "#{ENV[env_var]} is not a valid value for #{ENV[env_var]}" \
      if !supported_env_var_values.contains? ENV[env_var]
  end
end

namespace :unit do
  RSpec::Core::RakeTask.new(:rspec) do
    task.pattern = Dir.glob('spec/**/*_spec.rb')
    task.rspec_opts = '--format documentation'
  end
end

task :default => [ 'check_env_vars', 'unit:rspec' ]
