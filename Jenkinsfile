pipeline{
    agent {
        node {
            label 'build-server'
        }
    }
environment {
    PATH="/opt/apache-maven-3.9.5/bin:$PATH"
}
stages{
   
    stage('build'){
        steps{
        sh 'mvn clean deploy -Dmaven.test.skip=true'
    }
}
stage('sonar scanner'){
    environment {
        scannerHome = tool 'sonar-tool'
    }
    steps{
        withSonarQubeEnv('sonar-server') { 
            sh "${scannerHome}"/bin/sonnar-scanner
    }
}
}