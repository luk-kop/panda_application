pipeline {
    agent {
		label 'slave-docker'
	}
    tools {
        maven 'M3.6.3'
    }
        environment {
		CONTAINER_NAME = 'pandaapp'
        IMAGE = sh script: 'mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout', returnStdout: true
        VERSION = sh script: 'mvn help:evaluate -Dexpression=project.version -q -DforceStdout', returnStdout: true
	}
    stages {
        stage('Clear running apps') {
            steps {
                // Clear previous instances of app build
                sh "docker rm ${CONTAINER_NAME} -f || true"
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
        stage('Run Docker container') {
            steps {
                sh "docker run -d -p 8080:8080 --name ${CONTAINER_NAME} ${IMAGE}:${VERSION}"
            } 
        }
        stage('Test Selenium') {
            steps {
                sh "mvn test -Pselenium"
            } 
        }
        stage('Application deployment') {
            steps {
                withMaven(globalMavenSettingsConfig: 'null', jdk: 'null', maven: 'M3.6.3', mavenSettingsConfig: '36a02879-07cb-4ab3-8f5c-85a05dd037d9') {
                    sh "mvn deploy"
                }
            } 
        }
    }
    post {
        // If Maven was able to run the tests, even if some of the test
        // failed, record the test results and archive the jar file.
        success {
            junit '**/target/surefire-reports/TEST-*.xml'
            archiveArtifacts 'target/*.jar'
            sh "docker stop ${CONTAINER_NAME}"
            deleteDir()
        }
    }
}