require 'spec_helper'

describe Infrastructure::Core::AWS::MainVPC do
  aws_regions_to_contain_a_vpc = @infrastructure_config['vpc']['regions']
  vpc_cidr_block = @infrastructure_config['vpc']['cidr_block']

  aws_regions_to_contain_a_vpc.each do |aws_region|
    describe 'vpc_presence' do
      it "Should exist in this region: #{aws_region}" do
        pass
      end
    end

    describe 'vpc_properties' do
      it "Should have DNS hostnames enabled" do
        pass
      end
      it "Should have DNS resolution enabled" do
        pass
      end
      it "Should be using this VPC CIDR block: #{vpc_cidr_block}" do
        pass
      end
    end

    describe 'network_acls' do
      it "Should have no Network ACLs defined" do
        pass
      end
    end

    describe 'vpc_flow_logs' do
      it "Should have VPC flow logs turned off" do
        pass
      end
    end
  end
end
