pipeline {
    agent any

    stages {
        stage('Pulling') {
            steps {
		echo 'Pulling'
		sh 'if [ ! -d "jenkins-counter_app" ] ; then 
			git clone https://github.com/currentlib/jenkins-counter_app
		    else
			cd jenkins-counter_app
			git pull https://github.com/currentlib/jenkins-counter_app
		    fi'	
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
