pipeline {
  agent any
  stages {
    stage('Initialize') {
      steps {
        sh 'which bundler || gem install bundler'
        sh 'bundle install'
      }
      build 'Unit Tests'
    }
    stage('Unit Tests') {
      steps {
        sh 'bundle exec rake unit'
        build 'Integration'
      }
    }
    stage('Integration') {
      steps {
        sh 'bundle exec rake integration'
        build 'Deploy'
      }
    }
    stage('Deploy') {
      steps {
        sh 'bundle exec rake deploy'
      }
    }
  }
}
