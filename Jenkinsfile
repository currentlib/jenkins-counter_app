pipeline {
    agent any

    stages {
        stage('Pulling') {
            steps {
		cd jenkins-counter_app
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
		sh 'ls -lsa'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
