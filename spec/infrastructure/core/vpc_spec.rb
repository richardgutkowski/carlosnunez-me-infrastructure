require 'spec_helper'
require 'awspec'

describe "Terraform plan" do
  it "should not have failed to run" do
    expect($terraform_plan_stderr).to be_empty
  end
  it "should exist" do
    expect($terraform_plan).not_to be_nil
  end
end
