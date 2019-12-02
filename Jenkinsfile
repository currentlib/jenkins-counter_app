pipeline {
    agent {
        label 'ubuntu'
    }
    environment {
        registry = "artshoque/important-site"
        registryCredential = 'dockerhub'
        dockerImage = ''
        dockerImageNumbered = ''
        curlState = 'up'
        dockerImageErr = 'ok'
        dockerImageNumberedErr = 'ok'
        dockerImagePushErr = 'ok'
        dockerImageNumberedPushErr = 'ok'
        publishArtifactErr = 'ok'
        publishPullErr = 'ok'
    }

    stages {
        stage('Pull') {
            steps {
                echo 'Pulling..'
                script {
                    sh 'git clone https://github.com/currentlib/jenkins-counter_app'
                    sh 'cd jenkins-counter_app'
                }
            }
        }

        stage('Build') {
            steps {
                echo 'Building..'
                script {
                    try {
                        dockerImage = docker.build registry + ":dev"
                    }
                    catch (err) {
                        dockerImageErr = err
                    }
                    
                    try {
                        dockerImageNumbered = docker.build registry + ":$BUILD_NUMBER"
                    }
                    catch (err) {
                        dockerImageNumberedErr = err
                    }
                }
            }
        }

        stage('Push') {
            steps {
                echo 'Pushing..'
                script {
                    try {
                        docker.withRegistry( '', registryCredential ) {
                            dockerImage.push()
                        }
                    }
                    catch (err) {
                        dockerImagePushErr = err
                    }
                    
                    try {
                        docker.withRegistry( '', registryCredential ) {
                            dockerImageNumbered.push()
                        }
                    }
                    catch (err) {
                        dockerImageNumberedPushErr = err
                    }
                }
            }
        }

        stage('Deploy..') {
            steps {
                echo 'Deploying..'
                script {
                    try {
                        sshPublisher(
                            publishers: [
                                sshPublisherDesc(
                                    configName: 'g11hacha11@test-server', 
                                    transfers: [
                                        sshTransfer(
                                            cleanRemote: false, 
                                            excludes: '', 
                                            execCommand: 'docker pull artshoque/important-site:dev \
                                                          && cd jenkins-counter_app/ \
                                                          && docker-compose up -d --scale homework=$scaleNumber', 
                                            execTimeout: 120000, 
                                            flatten: false, 
                                            makeEmptyDirs: false, 
                                            noDefaultExcludes: false, 
                                            patternSeparator: '[, ]+', 
                                            remoteDirectory: 'jenkins-counter_app/', 
                                            remoteDirectorySDF: false, 
                                            removePrefix: '', 
                                            sourceFiles: 'docker-compose.yaml'
                                        )
                                    ], 
                                    usePromotionTimestamp: false, 
                                    useWorkspaceInPromotion: false, 
                                    verbose: false
                                )
                            ]
                        )
                    }
                    catch (err) {
                        publishPullErr = err
                    }
                }
            }
        }
    }

    post {
        always {
            telegramSend """Job status: other

STAGES STATUS

Dev Image: $dockerImageErr
Numbered Image: $dockerImageNumberedErr
Dev Image Push: $dockerImagePushErr
Numbered Image Push: $dockerImageNumberedPushErr
Sending docker-compose: $publishArtifactErr
Deploying to Remote Server: $publishPullErr
"""
            cleanWs()
        }
        success {
            script {
                try {
                    sleep(time:5,unit:"SECONDS")
                    sh 'curl http://34.69.46.182:80/'
                }
                catch (err) {
                    curlState = err
                }
                finally {
                    telegramSend """Job status: success
                    
App name: $registry:$BUILD_NUMBER
Server name: g11hacha11@test-server
Server status: $curlState


STAGES STATUS

Dev Image: $dockerImageErr
Numbered Image: $dockerImageNumberedErr
Dev Image Push: $dockerImagePushErr
Numbered Image Push: $dockerImageNumberedPushErr
Sending docker-compose: $publishArtifactErr
Deploying to Remote Server: $publishPullErr
"""
                }
                cleanWs()
            }
        }
        failure {
            script {
                telegramSend """Job status: failed 
                
Dev Image: $dockerImageErr
Numbered Image: $dockerImageNumberedErr
Dev Image Push: $dockerImagePushErr
Numbered Image Push: $dockerImageNumberedPushErr
Sending docker-compose: $publishArtifactErr
Deploying to Remote Server: $publishPullErr
"""
            }
            cleanWs()
        }
    }
}