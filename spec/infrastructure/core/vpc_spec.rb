require 'spec_helper'
require 'awspec'

describe "VPC" do
  before(:all) do
    @vpc_details = $terraform_plan['aws_vpc.infrastructure']
  end
  it "should have the right CIDR block" do
    cidr_block_expected = $terraform_tfvars['aws_vpc_cidr_block']
    expect(@vpc_details['cidr_block']).to eq(cidr_block_expected)
  end
end
