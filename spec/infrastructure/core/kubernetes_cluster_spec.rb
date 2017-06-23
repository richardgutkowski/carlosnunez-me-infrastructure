require 'spec_helper'
require 'set'

describe "KubernetesCluster" do
  before(:all) do
    @vpc_details = $terraform_plan['aws_vpc.infrastructure']
    @coreos_amis = obtain_latest_coreos_version_and_ami!
    let(:controllers_found) = $terraform_plan['kubernetes-cluster'].select do |key,value|
      key.match /aws_instance\.kubernetes_controller/
    end
  end

  context "Controller" do
    context "Metadata" do
      it "should have retrieved EC2 details" do
        expect(controllers_found).not_to be_nil
      end
    end

    context "Sizing" do
      it "should be defined" do
        expect($terraform_tfvars['kubernetes_controller_count']).not_to be_nil
      end
      
      
      it "should be replicated the correct number of times within this AZ" do
        expected_number_of_kube_controllers = \
          $terraform_tfvars['kubernetes_controller_count']
        expect(controllers_found.count).to be eq expected_number_of_kube_controllers

        # We aren't testing that these controllers actually have AZs
        # (it can be empty if not defined). We're solely testing that 
        # they are the same within this AZ.
        azs_for_each_controller = controllers_found.values.map do |controller_config|
          controller_config['availability_zone']
        end
        deduplicated_az_set = Set.new(azs_for_each_controller)
        expect(deduplicated_az_set.count).to be eq 1
      end
    end

    controllers_found.keys.each do |kube_controller|
      it "should be fetching the latest stable release of CoreOS for region \
        #{ENV['AWS_REGION']}" do
          this_controller_details = controllers_found[kube_controller]
          expected_ami_id = @coreos_amis[ENV['AWS_REGION']]['hvm']
          actual_ami_id = this_controller_details['ami']
          expect(expected_ami_id).to eq expected_ami_id
      end
    end
  end
end
