require 'spec_helper'

describe Infrastructure::Core::AWS::MainVPC do
  aws_regions_containing_this_vpc = @infrastructure_config['vpc']['regions']
  vpc_cidr_block = @infrastructure_config['vpc']['cidr_block']

  aws_regions_containing_this_vpc.each do |aws_region|
    describe 'vpc_presence' do
      it "Should exist in this region: #{aws_region}" do
      end
    end

    describe 'subnets' do
      it "Should be using CIDR #{vpc_cidr_block} for its default subnet" do
      end
    end
    describe 'core_security_groups' do
    end
    describe 'network_acls' do
    end
    describe 'vpc_flow_logs' do
    end
  end
end
