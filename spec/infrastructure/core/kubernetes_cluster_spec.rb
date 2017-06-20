require 'spec_helper'

describe "KubernetesCluster" do
  before(:all) do
    @vpc_details = $terraform_plan['aws_vpc.infrastructure']
    @controller_details =
      $terraform_plan['kubernetes-cluster']['aws_instance.kubernetes_controller']
  end

  context "Metadata" do
    it "should have retrieved EC2 details" do
      expect(@ec2_details).not_to be_nil
    end
  end

  context "VPC" do
    it "should have a dependency on the 'infrastructure' VPC" do
      expect(@ec2_details['depends_on']).to contain 'aws_vpc.infrastructure'
    end
    it "should use the subnet ID of the 'infrastructure' VPC" do
      expect(@ec2_details['subnet_id']).to eq @vpc_details['subnet_id']
    end
  end

  context "Controller" do
    it "should be fetching the latest stable release of CoreOS for region \
#{ENV['AWS_REGION']}" do
      latest_hvm_coreos_ami_for_this_region =
        $coreos_amis[ENV['AWS_REGION']]['hvm']
      expect(@controller_details['ami']).to \
        eq latest_hvm_coreos_ami_for_this_region
    end
  end
end
