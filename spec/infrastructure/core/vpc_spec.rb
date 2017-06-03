require 'spec_helper'

vpcs = @infrastructure_config['aws']['vpc']
vpcs.each do |vpc|
end

# --- old ---
vpcs = @infrastructure_config['vpc']
vpcs.each do |vpc|
  vpc_name = vpc['name']
  vpc_cidr_block = vpc['cidr_block']
  vpc_tags = vpc['tags']
  describe vpc(vpc_name) do
    it { should exist }
    it { should be_available }
    its('is_default') { should be_false }
    its('cidr_block') { should eq vpc_cidr_block }
  end
end
