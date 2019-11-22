pipeline {
    agent any
    environment {
	    registry = "artshoque/important-site"
	    registryCredential = 'dockerhub'
	    dockerImage = ''
    }

    stages {
        stage('Pulling') {
            steps {
		        echo 'Pulling'
		        sh 'git clone https://github.com/currentlib/jenkins-counter_app'
		        sh 'cd jenkins-counter_app'
            }
        }
        stage('Building..') {
            steps {
                echo 'Building..'
		        script {
		            dockerImage = docker.build registry + ":$BUILD_NUMBER"
		        }
            }
        }
        stage('Dockerhubing') {
            steps {
                echo 'Dockerhubing.... bless rng'
		        script {
		            docker.withRegistry( '', registryCredential ) {
			            dockerImage.push()
		            }
		        }
		        sh 'cd ..'
		        sh 'rm -r -f jenkins-counter_app'
		        sh 'docker rmi $registry:$BUILD_NUMBER'
		    }
        }
        stage('Deploy..') {
            steps {
                echo 'Deplofsdfdsy to remote server..'
                script {
                    try {
                        sshPublisher(publishers: [sshPublisherDesc(configName: 'g11hacha11@test-server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'docker rm -f $(docker ps -a -q)', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
                    }

                    finally {
                        sshPublisher(publishers: [sshPublisherDesc(configName: 'g11hacha11@test-server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'docker run -it -d -p 5000:5000 $registry:$BUILD_NUMBER', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])           
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWS()
        }
    }
}




