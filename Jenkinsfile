pipeline {
  agent any
  stages {
    stage('Initialise') {
      steps {
        sh 'which bundler || gem install bundler --user-install'
        sh 'bundle install'
      }
    }
    stage('Retrieve Configurations and Terraform binary') {
      steps {
        sh 'aws s3 cp s3://$AWS_S3_TERRAFORM_TFVARS_BUCKET/$TARGET_ENVIRONMENT/terraform.tfvars ./terraform.tfvars'
      }
    }
    stage('Unit Tests') {
      steps {
        sh 'bundle exec rake unit'
      }
    }
    stage('Integration Tests') {
      steps {
        sh 'bundle exec rake integration'
      }
    }
    stage('Deploy to environment') {
      steps {
        sh 'bundle exec rake deploy'
      }
    }
    stage('Upload Terraform state') {
      steps {
        sh 'aws s3 cp terraform.tfstate s3://$AWS_S3_TERRAFORM_STATE_BUCKET/terraform.tfstate'
      }
    }
  }
}
