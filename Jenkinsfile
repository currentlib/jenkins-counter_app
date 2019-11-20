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
			sh 'pwd'
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
        stage('Dockerhub') {
            steps {
                echo 'Dockerhubing....'
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
	stage('Deploy') {
	    steps {
		echo 'Deploing...'
			script {
				sshPublisher(
				    publishers: [
						sshPublisherDesc(
							configName: 'g11hacha11@test-server', 
							transfers: [
								sshTransfer(
									cleanRemote: false, 
									excludes: '', 
									execCommand: 'ls', 
									execTimeout: 120000, 
									flatten: false, 
									makeEmptyDirs: false, 
									noDefaultExcludes: false, 
									patternSeparator: '[, ]+', 
									remoteDirectory: '', 
									remoteDirectorySDF: false, 
									removePrefix: '', 
									sourceFiles: ''
								)
							], 
							usePromotionTimestamp: false, 
							useWorkspaceInPromotion: false, 
							verbose: false
						)
				    ]
				)
			}
    }
}




