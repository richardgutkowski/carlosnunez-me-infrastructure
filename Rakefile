require 'rspec/core/rake_task'

namespace :prerequisites do
  required_env_vars = [ 'TARGET_ENVIRONMENT' ]
  required_env_vars.each do |env_var|
    raise "#{env_var} is not defined in your environment; please define it." if !ENV[env_var]
  end
end

namespace :unit do
  RSpec::Core::RakeTask.new(:rspec) do
    task.pattern = Dir.glob('spec/**/*_spec.rb')
    task.rspec_opts = '--format documentation'
  end
end

task :default => [ 'prerequisites', 'unit:rspec' ]
