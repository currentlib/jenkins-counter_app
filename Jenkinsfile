pipeline {
    agent any
    environment {
	    registry = "artshoque/important-site"
	    registryCredential = 'dockerhub'
	    dockerImage = ''
        dockerImageNumbered = ''
        curlState = 'up'
        dockerImageErr = ''
        dockerImageNumberedErr = ''
        dockerImagePushErr = ''
        dockerImageNumberedPushErr = ''
        publishArtifactErr = ''
        publishPullErr = ''
    }

    stages {

        stage('Pulling') {
            steps {
		        echo 'Pulling..'
                script {
                    try {
                        sh 'rm -r -f jenkins-counter_app/'
                    }
                    catch (err) {
                        echo '$err'
                    }
                    finally {
                        sh 'git clone https://github.com/currentlib/jenkins-counter_app'
                        sh 'cd jenkins-counter_app'
                    }
                }
            }
        }

        stage('Building') {
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

        stage('Pushing') {
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
                            dockerImageNumbereds.push()
                        }
                    }
                    catch (err) {
                        dockerImageNumberedPushErr = err
                    }
		        }
		        sh 'cd ..'
		        sh 'rm -r -f jenkins-counter_app'
		    }
        }

        stage('Deploy..') {
            steps {
                echo 'Deploying..'
                script {
                    try {
                        sshPublisher(publishers: [sshPublisherDesc(configName: 'g11hacha11@test-server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: 'jenkins-counter_app/', remoteDirectorySDF: false, removePrefix: '', sourceFiles: 'docker-compose.yaml')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
                    }
                    catch (err) {
                        publishArtifactErr = err
                    }
                    
                    try {
                        sshPublisher(publishers: [sshPublisherDesc(configName: 'g11hacha11@test-server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'docker pull artshoque/important-site:dev && cd jenkins-counter_app/ && docker-compose up -d --scale homework=4', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
                    }
                    catch (err) {
                        publishPullErr = err
                    }
                }
            }
        }
    }

    post {
        success {
            script {
                try {
                    sh 'curl http://34.69.46.182:8080/'
                }
                catch (err) {
                    curlState = err
                }
                finally {
                    telegramSend """Build and deploy is ok
                    
App name: $registry:$BUILD_NUMBER
Server name: g11hacha11@test-server
Server status: $curlState
                                 """
                }
            }
        }
        failure {
            script {
                telegramSend """Build or deploy is NOT ok
                
ImageDev: $dockerImageErr
ImageNumbered: $dockerImageNumberedErr
ImagePush: $dockerImagePushErr
ImageNumberedPush: $dockerImageNumberedPushErr
docker-compose.yaml: $publishArtifactErr
pull and run: $publishPullErr
"""
            }
        }
    }
}