require 'spec_helper'
require 'awspec'

describe "Terraform plan" do
  it "should exist" do
    expect($terraform_plan).not_to be_nil
  end
end
