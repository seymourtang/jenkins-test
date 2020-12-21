pipeline {
  agent any
  stages {
    stage('pull') {
      agent any
      steps {
        echo 'starting checkout'
        checkout scm
        echo 'end checkout'
      }
    }

  }
}
