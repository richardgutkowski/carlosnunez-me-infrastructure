pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        sh 'which bundler || gem install bundler'
        sh 'bundle install'
      }
      build 'unitTests'
    }
    stage('unitTests') {
      steps {
        sh 'bundle exec rake unit'
        build 'integrationTests'
      }
    }
    stage('integrationTests') {
      steps {
        sh 'bundle exec rake integration'
        build 'deploy'
      }
    }
    stage('deploy') {
      steps {
        sh 'bundle exec rake deploy'
      }
    }
  }
}
