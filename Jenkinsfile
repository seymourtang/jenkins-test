pipeline {
  agent any
  stages {
    stage('pull') {
      agent any
      steps {
        echo 'starting checkout'
        checkout(scm: checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'CleanBeforeCheckout']], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github', url: 'https://github.com/seymourtang/jenkins-test']]]), changelog: true, poll: true)
        echo 'end checkout'
      }
    }

  }
}