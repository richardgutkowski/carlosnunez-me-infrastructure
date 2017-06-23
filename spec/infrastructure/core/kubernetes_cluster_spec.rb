require 'spec_helper'

describe "KubernetesCluster" do
  before(:all) do
    @vpc_details = $terraform_plan['aws_vpc.infrastructure']
    @controller_details =
      $terraform_plan['kubernetes-cluster']['aws_instance.kubernetes_controller']
  end

  context "Controller" do
    context "Metadata" do
      it "should have retrieved EC2 details" do
        expect(@controller_details).not_to be_nil
      end
    end

    it "should be fetching the latest stable release of CoreOS for region \
#{ENV['AWS_REGION']}" do
      latest_hvm_coreos_ami_for_this_region =
        $coreos_amis[ENV['AWS_REGION']]['hvm']
      expect(@controller_details['ami']).to \
        eq latest_hvm_coreos_ami_for_this_region
    end

    it "should be replicated three times within this AZ" do
      expect($terraform_tfvars['controller_count']).not_to be_nil
      expect(@controller_details['count']).to be \
        eq $terraform_tfvars['controller_count']
    end
  end
end
