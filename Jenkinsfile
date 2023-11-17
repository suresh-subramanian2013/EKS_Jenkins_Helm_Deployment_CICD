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
        stage('test') {
            steps {
                script {
                    sh 'mvn clean deploy'
                    sh 'mvn clean deploy -Dmaven.test.skip=true '
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
        stage('Quality Gates') { // Corrected the stage declaration
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') {
                        // Just in case something goes wrong, the pipeline will be killed after a timeout
                        def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }
        // stage('mvn build'){
        //     steps{
        //         sh 'mvn clean deploy'
        //     }
        // }
    }
}
