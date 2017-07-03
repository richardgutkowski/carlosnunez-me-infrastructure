def process_env_vars!(required_env_vars:, optional_env_vars:)
  parsed_options = {
    :error_messages => []
  }
  required_env_vars.each do |env_var, env_var_properties|
    actual_env_var_value = ENV[env_var]
    if actual_env_var_value.nil? or actual_env_var_value.empty?
      if not env_var_properties[:default_value].nil?
        actual_env_var_value = env_var_properties[:default_value]
      else
        parsed_options[:error_messages].push
          "ERROR: Required environment variable not found: #{env_var}".red
      end
    end
    supported_env_var_values = env_var_properties[:supported_values]
    if not supported_env_var_values.nil? and
      not supported_env_var_values.include? actual_env_var_value
      parsed_options[:error_messages].push
        "ERROR: \"#{actual_env_var_value}\" is not supported. \
Supported values are: #{supported_env_var_values}".red
    end
    parsed_options[env_var.downcase.to_sym] = actual_env_var_value
  end

  optional_env_vars.each do |env_var, env_var_properties|
    actual_env_var_value = ENV[env_var]
    if actual_env_var_value.nil? and not env_var_properties[:default_value].nil?
      actual_env_var_value = env_var_properties[:default_value]
    end
    parsed_options[env_var.downcase.to_sym] = actual_env_var_value
  end
end
