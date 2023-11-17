pipeline {
    agent {
        node {
            label 'build-server'
        }
    }
    environment {
        PATH = "/opt/apache-maven-3.9.5/bin:$PATH"
    }
    stages {
        stage('Build') {
            steps {
                script {
                    sh 'mvn clean deploy -Dmaven.test.skip=true'
                }
            }
        }
        stage('Sonar Scanner') {
            environment {
                scannerHome = tool 'sonar-tool'
            }
            steps {
                script {
                    withSonarQubeEnv('sonar-server') {
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }
    }
}
