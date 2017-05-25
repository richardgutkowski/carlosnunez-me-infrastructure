def load_config(environment)
  file_to_load = "config/infrastructure_config.#{environment}.yml"
  if not File.exist? file_to_load
    raise "#{file_to_load} not found."
  end
  YAML.load_file(file_to_load)
end
