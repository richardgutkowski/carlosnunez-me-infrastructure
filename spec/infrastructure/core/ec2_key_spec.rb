require 'spec_helper'

describe "EC2Key" do
  before(:all) do
    @ec2_key_details = $terraform_plan['aws_key_pair.all_nodes']
  end

  it "should be present" do
    expect(@ec2_key_details).not_to be_nil
  end

  it "should get the key name specified" do
    expected_key_name = $terraform_tfvars['ec2_key_name']
    actual_key_name = @ec2_key_details['key_name']
    expect(expected_key_name).to eq actual_key_name
  end
end
