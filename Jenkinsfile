pipeline {
    agent any

    stages {
        stage('Pulling') {
            steps {
                echo 'Checking git repo folder'
		script {
			if ([ -d "jenkins-counter_app" ]) {
				cd jenkins-counter_app
			} else {
				git clone https://github.com/currentlib/jenkins-counter_app
				cd jenkins-counter_app
			}
		}
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
