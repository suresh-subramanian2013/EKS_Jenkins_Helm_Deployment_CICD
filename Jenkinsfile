pipeline{
    agent build-server
    stages {
        stage('git checkout'){
            steps {
                git branch: 'main' url: 'https://github.com/ravipramoth/tweet-trend-new.git'
            }
        }
    }
}