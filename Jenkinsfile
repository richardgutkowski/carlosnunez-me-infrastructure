pipeline {
  agent any
  stages {
    stage('Initialise') {
      steps {
        sh 'which bundler || gem install bundler'
        sh 'bundle install'
      }
    }
    stage('Example') {
      steps {
        echo "Hi! I'm in a stage step!"
      }
    }
  }
}
