pipeline {
    agent any
    environment {
        ECR_Reponame="spring-app"
        TagName="latest"
        Stackname="mystack"
        Dockerimage="vkavu/${ECR_Reponame}:latest"
        AWSRegion="us-east-1"
    }
    
    stages {
        stage('Build') {
            steps {
                sh './gradlew assemble'
            }
        }
        stage('Test') {
            steps {
                sh './gradlew test'
            }
        }
        stage('Build Docker image') {
            steps {
                sh './gradlew docker -PDockerimage=$Dockerimage'
            }
        }
        stage('Push Docker image') {
            environment {
                DOCKER_HUB_LOGIN = credentials('docker-hub')
            }
            steps {
                sh 'make push2hub'
                //sh 'docker login --username=$DOCKER_HUB_LOGIN_USR --password=$DOCKER_HUB_LOGIN_PSW'
                //sh './gradlew dockerPush -PdockerHubUsername=$DOCKER_HUB_LOGIN_USR'
            }
        }
        stage('Push to ECR') {
            steps {
                withAWS(credentials: 'awscredential', region: env.AWSRegion){
                    sh 'make push2ecr'
                }
            }
        }
        stage('Deploy to AWS') {
           steps {
                withAWS(credentials: 'awscredential', region: env.AWSRegion){
                    sh 'make deploy_ecs'
                }
            }
        }
    }
}