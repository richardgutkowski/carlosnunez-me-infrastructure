require 'spec_helper'
require 'awspec'

describe "Terraform plan" do
  it "should not have failed to run" do
    puts "Terraform plan errors: #{$terraform_plan_stdout}"
    $terraform_plan_stderr.should be_empty
  end
  it "should exist" do
    $terraform_plan.should_not be_empty
  end
end
