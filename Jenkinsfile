pipeline {
    agent {
		label 'Slave'
	}
    tools {
        maven 'M3.6.3'
        terraform 'Terraform'
    }
    environment {
		CONTAINER_NAME = 'pandaapp'
        IMAGE = sh script: 'mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout', returnStdout: true
        VERSION = sh script: 'mvn help:evaluate -Dexpression=project.version -q -DforceStdout', returnStdout: true
        ANSIBLE = tool name: 'Ansible', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'
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
                sh "mvn package -Pdocker -Dmaven.test.skip=true"
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
                configFileProvider([configFile(fileId: '36a02879-07cb-4ab3-8f5c-85a05dd037d9', variable: 'MAVEN_GLOBAL_SETTINGS')]) {
                    sh "mvn -gs ${MAVEN_GLOBAL_SETTINGS} deploy -Dmaven.test.skip=true -e"
                }
            } 
        }
        stage('Run terraform') {
            steps {
                dir('infrastructure/terraform') {
                    // credential (Secret file) with id 'terraform-pem' is injected to temp var 'terraformpanda' and then is stored as 'panda.pem'
                    withCredentials([file(credentialsId: 'terraform-pem', variable: 'terraformpanda')]) { sh "cp \$terraformpanda ../panda.pem" }
                    // AWS credentials
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS']]) {
                        sh 'terraform init && terraform apply -auto-approve -var-file panda.tfvars'
                    }
                }
            }
        }
        stage('Copy Ansible role') {
            steps {
                sh 'sleep 180'
                sh 'cp -r infrastructure/ansible/panda /etc/ansible/roles/'
            }
        }
        stage('Run Ansible') {
            steps {
                dir('infrastructure/ansible') {
                     sh 'chmod 400 ../panda.pem'
                     sh 'ansible-playbook -i ./inventory playbook.yml -e ansible_python_interpreter=/usr/bin/python3'
                }
            }
        }
        stage('Remove environment') {
            steps {
                input 'Remove environment' 
                dir('infrastructure/terraform') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS']]) {
                            sh 'terraform destroy -auto-approve -var-file panda.tfvars'
                        }
                }
            }
        }
    }
    post {
        success {
            junit '**/target/surefire-reports/TEST-*.xml'
            archiveArtifacts 'target/*.jar'
            sh "docker stop ${CONTAINER_NAME} || true"
            deleteDir()
        }
        failure {
            dir('infrastructure/terraform') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS']]) {
                        sh 'terraform destroy -auto-approve -var-file panda.tfvars'
                    }
                }
                sh "docker stop ${CONTAINER_NAME}"
                deleteDir()
        }
    }
}