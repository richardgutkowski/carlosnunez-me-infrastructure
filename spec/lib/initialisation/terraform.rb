def initialise_global_terraform_plan!
  tfjson_location = [ ENV['GOPATH'], 'bin', 'tfjson' ].join('/')
  if not File.exist? tfjson_location
    raise "tfjson not found. Rakefile should have installed it..."
  end

  print "INFO: Generating Terraform plan now. This might take a short while...".yellow
  system("#{ENV['PWD']}/terraform get > /dev/null")
  system("#{ENV['PWD']}/old_terraform plan \
-var aws_region=#{ENV['AWS_REGION']} \
-state=discarded_state_not_required_for_unit_tests \
-out=terraform_fixture.tfplan > /dev/null")

  terraform_plan_json_serialized = `#{tfjson_location} ./terraform_fixture.tfplan`
  if terraform_plan_json_serialized.nil? or terraform_plan_json_serialized.empty?
    raise "Mock Terraform plan was not generated. See above errors for more details."
  end
  puts "done!".green
  temp_tfplan_json_file_for_future_perusal = '/tmp/terraform_plan.json'
  if File.exist? temp_tfplan_json_file_for_future_perusal
    `rm -f #{temp_tfplan_json_file_for_future_perusal} 2>/dev/null`
  end
  File.open(temp_tfplan_json_file_for_future_perusal, 'w') do |file_handle|
    file_handle.write(terraform_plan_json_serialized)
  end
  puts "INFO: A copy of the terraform plan JSON generated for this run can \
be found at #{temp_tfplan_json_file_for_future_perusal}".cyan

  terraform_plan = JSON.parse(terraform_plan_json_serialized)
  return terraform_plan
end

def initialise_global_terraform_tfvars!
  terraform_tfvars = {}
  File.open("#{ENV['PWD']}/terraform.tfvars",'r').map do |line|
    tfvar_key, tfvar_value = line.split('=').map do |item|
      item.sub('"','').gsub("\n",'').gsub(' ','').gsub('"','')
    end
    terraform_tfvars[tfvar_key] = tfvar_value
  end
  return terraform_tfvars
end
