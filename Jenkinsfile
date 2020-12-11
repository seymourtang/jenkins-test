pipeline {
    agent any
    stages {
        stage('拉取代码'){
            steps {
              checkout([$class: 'GitSCM', branches: [[name: '${Branch}']], userRemoteConfigs: [[credentialsId: "${git_auth}", url: "${git_address}"]]])
            }
        }
    }
}