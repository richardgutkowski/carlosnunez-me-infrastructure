require 'spec_helper'
require 'awspec'

describe "Terraform plan" do
  it "Should exist" do
    puts "Terraform plan: #{$terraform_plan}, is_nil: #{$terraform_plan.nil?}"
    $terraform_plan.nil? == false
  end
end
