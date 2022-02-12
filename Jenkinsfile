pipeline {
    agent any
    environment {
        ECR_Reponame="spring-app"
        TagName="latest"
        Stackname="mystack"
        Dockerimage="vkavu/${ECR_Reponame}:latest"
        AWSRegion="us-east-1"
    }

    triggers {
        pollSCM '* * * * *'
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
