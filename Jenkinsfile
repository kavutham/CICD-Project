pipeline {
    agent any
    environment {
        ECR_Reponame="spring-app"
        TagName="${env.BUILD_ID}"
        Stackname="mystack"
        Dockerimage="vkavu/${ECR_Reponame}:${env.BUILD_ID}"
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
        stage('Push Docker image') {
            environment {
                DOCKER_HUB_LOGIN = credentials('docker-hub')
            }
            steps {
                sh 'docker login --username=$DOCKER_HUB_LOGIN_USR --password=$DOCKER_HUB_LOGIN_PSW'
                sh './gradlew dockerPush -PdockerHubUsername=$DOCKER_HUB_LOGIN_USR'
            }
        }
        stage('Push to ECR') {
            steps {
                withAWS(credentials: 'awscredential', region: env.AWS_REGION){
                    make push_to_ecr
                }
            }
        }
        stage('Deploy to AWS') {
           steps {
                withAWS(credentials: 'awscredential', region: env.AWS_REGION){
                    make deploy_ecs
                }
            }
        }
    }
}