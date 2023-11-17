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
    stage('Checkout'){
        steps{
            git branch: 'main', changelog: false, poll: false, url: 'https://github.com/ravipramoth/tweet-trend-new.git'
        }
    }
    stage('build'){
        steps{
        sh 'mvn clean deploy -Dmaven.test.skip=true'
    }
}
}
}