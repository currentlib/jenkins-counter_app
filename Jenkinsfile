pipeline {
    agent any

    stages {
        stage('Pulling') {
            steps {
		echo 'Pulling'
		sh 'git clone https://github.com/currentlib/jenkins-counter_app'
		sh 'cd jenkins-counter_app'
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
		sh 'cd ..'
		sh 'rm -r jenkins-counter_app'
            }
        }
    }
}
