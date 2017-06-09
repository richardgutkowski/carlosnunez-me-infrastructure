require 'spec_helper'
require 'awspec'

describe "Terraform plan" do
  it "should exist" do
    puts "Terraform plan: #{$terraform_plan}, is_nil: #{$terraform_plan.nil?}"
    $terraform_plan.should_not be_nil
  end
end
