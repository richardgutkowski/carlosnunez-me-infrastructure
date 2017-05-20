def load_config
  if not File.exist? 'config/infrastructure_config.yml'
    raise FileNotFoundException, 'config/infrastructure_config.yml not found' 
  end
  YAML.load_file("config/infrastructure_config.yml")
end
