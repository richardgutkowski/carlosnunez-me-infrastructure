require 'spec_helper'
require 'awspec'

describe "Terraform plan" do
  it "should not have failed to run" do
    puts "Terraform plan errors: #{$terraform_plan_stdout}"
    $terraform_plan_stdout.should be_nil
  end
  it "should exist" do
    $terraform_plan.should_not be_nil
  end
end
