pipeline{
    agent build-server
    stages {
        stage('git checkout'){
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/ravipramoth/tweet-trend-new.git'
            }
        }
    }
}