def registry = 'https://pramoth28.jfrog.io/'
def imageName = 'https://pramoth28.jfrog.io/valaxy-docker-local/ttrend'
def version   = '2.1.2'
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
        stage('Quality Gates') {
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
        stage('jar Publish ') {
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
        stage('docker build') {
            steps {
                script {
                    app = docker.build(imageName + ":" + version)
                }
            }
        }
    }
}
