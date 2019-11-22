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
#			sh 'sudo rm -r -f /var/jenkins_home/workspace/pipe_counter/'
#			sh 'sudo rm -r -f /var/jenkins_home/workspace/pipe_counter@temp/'
		    }
        }
    }
}




