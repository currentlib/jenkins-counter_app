pipeline {
    agent any

    stages {
        stage('Pulling') {
            steps {
		echo 'Pulling'
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
            }
        }
    }
}
