def load_config(environment:)
  name_of_file_to_load = "config/infrastructure_config.#{environment}"
  valid_yaml_extensions = ['yml','yaml']
  valid_config_files_found = valid_yaml_extensions.map do |extension|
    file_to_find = "#{name_of_file_to_load}.#{extension}"
    if File.exist? file_to_find
      file_to_find
    end
  end.compact
  if valid_config_files_found.count > 1
    raise "Too many configuration files found for environment #{environment}: #{valid_config_files_found}"
  end
  file_to_load = valid_config_files_found.first
  yaml = YAML.load_file(file_to_load)
  puts "Testing that file got loaded"
  require 'pp'
  pp yaml
  yaml
end
