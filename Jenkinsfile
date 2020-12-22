pipeline {

    agent {
        kubernetes {
            yamlFile 'build/podTemplate.yaml'
            label 'adc-jenkins-test'
        }
    }

    stages {
        stage('Build Golang') {
            steps {
                echo 'build golang...'
                container('golang') {
                    sh """
                    GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -i -v -o ./bin/jenkins-test 	-ldflags "-s -w" ./cmd/main.go
                    ls -la
                    pwd
                    """
                }
            }
        }
    }
}