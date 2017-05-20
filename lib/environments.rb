def get_supported_environments
  Dir.glob('config/*.yaml').map do |file|
    file.split('.')[1]
  end
end
