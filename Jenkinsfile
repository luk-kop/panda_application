pipeline {
    agent {
		label 'slave-docker'
	}
    tools {
        maven 'M3.6.3'
    }

    stages {
        stage('Clear running apps') {
            steps {
                // Clear previous instances of app build
                sh 'docker rm pandaapp -f || true'
            }
        }
        // stage('Clone') {
        //     steps {
        //         git branch: 'main', url: 'https://github.com/luk-kop/panda_application.git'
        //     }
        // }
        
        stage('Build and Junit') {
            steps {
                // sh "mvn -Dmaven.test.failure.ignore=true clean install"
                sh "mvn clean install"
            }
        }
        stage('Build Docker image') {
            steps {
                sh "mvn package -Pdocker"
            } 
        }
        stage('Test Selenium') {
            steps {
                sh "mvn test -Pselenium"
            } 
        }
    }
    post {
        // If Maven was able to run the tests, even if some of the test
        // failed, record the test results and archive the jar file.
        success {
            junit '**/target/surefire-reports/TEST-*.xml'
            archiveArtifacts 'target/*.jar'
        }
    }
}