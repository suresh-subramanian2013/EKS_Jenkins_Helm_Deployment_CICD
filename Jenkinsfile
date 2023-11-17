pipeline {
    agent {
        node {
            label 'build-server'
        }
    }
    environment {
        PATH = "/opt/apache-maven-3.9.5/bin:$PATH"
        JAVA_Home = "jdk9"
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
 sh "${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=promoth-28_tweet-trend \
                            -Dsonar.organization=promoth-28 \
                            -Dsonar.projectName=tweet-trend \
                            -Dsonar.language=java \
                            -Dsonar.sourceEncoding=UTF-8 \
                            -Dsonar.sources=. \
                            -Dsonar.java.binaries=target/classes \
                            -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml"
                    }
                }
            }
        }
    }
}
