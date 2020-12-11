pipeline {
  agent any
  stages {
    stage('pull') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '${Branch}']], userRemoteConfigs: [[credentialsId: "${git_auth}", url: "${git_address}"]]])
      }
    }

  }
}