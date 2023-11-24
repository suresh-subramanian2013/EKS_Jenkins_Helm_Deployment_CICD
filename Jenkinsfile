def registry = 'https://suresh10214.jfrog.io/'
def imageName = 'suresh10214.jfrog.io/dockerdemo-local/ttrend'
def version = '2.1.2'

pipeline {
    agent {
        node {
            label 'build-server'
        }
    }

    parameters {
        choice(name: 'action', choices: 'Build\nDeploy', description: 'Choose Build/Deploy')
    }

    environment {
        PATH = "/opt/apache-maven-3.9.5/bin:$PATH"
    }

    stages {
        

        stage('Build') {
            when { expression { params.action == 'Build' } }
            steps {
                script {
                    sh 'mvn clean deploy -Dmaven.test.skip=true '
                }
            }
        }

        stage('Sonar Scanner') {
            environment {
                scannerHome = tool 'sonar-tool'
            }
            when { expression { params.action == 'Build' } }
            steps {
                script {
                    withSonarQubeEnv('sonar-server') {
                        sh "${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=promoth-28_jenkins-ci \
                            -Dsonar.organization=promoth-28 \
                            -Dsonar.projectName=Jenkins-ci \
                            -Dsonar.language=java \
                            -Dsonar.sourceEncoding=UTF-8 \
                            -Dsonar.sources=. \
                            -Dsonar.java.binaries=target/classes \
                            -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml"
                    }
                }
            }
        }

        stage('Quality Gates') {
            when { expression { params.action == 'Build' } }
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }

        stage('Jar Publish') {
            when { expression { params.action == 'Build' } }
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.newServer url: registry + "/artifactory", credentialsId: "artfiact-cred"
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/(*)",
                                "target": "libs-release-local/{1}",
                                "flat": "false",
                                "props": "${properties}",
                                "exclusions": ["*.sha1", "*.md5"]
                            }
                        ]
                    }"""
                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)
                    echo '<--------------- Jar Publish Ended --------------->'
                }
            }
        }

        stage('Docker Build') {
            when { expression { params.action == 'Build' } }
            steps {
                script {
                    app = docker.build(imageName + ":" + version)
                }
            }
        }

        stage("Docker Publish") {
            when { expression { params.action == 'Build' } }
            steps {
                
                script {
                    echo '<--------------- Docker Publisah Started --------------->'
                    docker.withRegistry(registry, 'artfiact-cred') {
                        app.push()
                    }
                    echo '<--------------- Docker Publish Ended --------------->'
                }
            }
        }

        stage('Deploy App') {
            when { expression { params.action == 'Deploy' } }
            steps {
                script {
                    sh './deploy.sh'
                }
            }
        }
    }
}
