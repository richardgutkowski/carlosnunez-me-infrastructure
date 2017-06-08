pipeline {
  agent any
  stages {
    stage('Initialise') {
      steps {
        sh 'which bundler || gem install bundler --user-install'
        sh 'bundle install'
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
  }
}
