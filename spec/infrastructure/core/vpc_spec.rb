require 'spec_helper'
require 'awspec'

describe "Terraform plan" do
  it "Should exist" do
    puts $terraform_plan
    $terraform_plan.nil? == false
  end
end
