pipeline {

    agent {
        kubernetes {
            yamlFile 'build/podTemplate.yaml'
            label 'adc-jenkins-test'
        }
    }

    stages {
        stage('lint') {
            steps {
                echo 'make lint...'
                container('golang') {
                    sh """
                    ls -la
                    pwd
                    make lint
                    """
                }
            }
        }
        stage('test') {
            steps {
                echo 'make test...'
                container('golang') {
                    sh """
                    ls -la
                    pwd
                    make test
                    """
                }
            }
        }
        stage('build') {
            steps {
                echo 'make build...'
                container('golang') {
                    sh """
                    ls -la
                    pwd
                    make build
                    """
                }
            }
        }
        stage('image') {
            steps {
                echo 'make image...'
                container('golang') {
                    sh """
                    ls -la
                    pwd
                    make image
                    """
                }
            }
        }
    }
}