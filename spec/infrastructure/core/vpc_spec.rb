require 'spec_helper'

describe "VPC" do
  before(:all) do
    @vpc_details = $terraform_plan['aws_vpc.infrastructure']
  end
  it "should have the right CIDR block" do
    cidr_block_expected = $terraform_tfvars['aws_vpc_cidr_block']
    expect(@vpc_details['cidr_block']).to eq(cidr_block_expected)
  end

  $terraform_tfvars['aws_regions'].each do |region|
    it "should have a VPC in region #{region}" do
      expect(@vpc_details['provider.region']).to eq region
    end
  end
end
