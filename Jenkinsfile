pipeline {
    agent any
    environment {
	    registry = "artshoque/important-site"
	    registryCredential = 'dockerhub'
	    dockerImage = ''
        dockerImageNumbered = ''
        curlState = 'up'
    }

    stages {

        stage('Pulling') {
            steps {
		        echo 'Pulling..'
                script {
                    try {
                        sh 'rm -r -f jenkins-counter_app/'
                    }
                    catch (error) {
                        echo '$error'
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
		            dockerImage = docker.build registry + ":dev"
                    dockerImageNumbered = docker.build registry + ":$BUILD_NUMBER"
		        }
            }
        }

        stage('Pushing') {
            steps {
                echo 'Pushing..'
		        script {
		            docker.withRegistry( '', registryCredential ) {
			            dockerImage.push()
		            }
                    docker.withRegistry( '', registryCredential ) {
			            dockerImageNumbered.push()
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
                    sshPublisher(publishers: [sshPublisherDesc(configName: 'g11hacha11@test-server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: 'jenkins-counter_app/', remoteDirectorySDF: false, removePrefix: '', sourceFiles: 'docker-compose.yaml')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
                    sshPublisher(publishers: [sshPublisherDesc(configName: 'g11hacha11@test-server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'docker pull artshoque/important-site:dev && cd jenkins-counter_app/ && docker-compose up -d --scale homework=4', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
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
                    telegramSend 'App name:      $registry:$BUILD_NUMBER\n
                                  Server name:   g11hacha11@test-server\n
                                  Server status: $curlState'
                }
            }
        }
    }
}




