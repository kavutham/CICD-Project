pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION="us-east-1"
        SUBNET_ID="subnet-0f9e260e7966a7012"
        VPCID="vpc-0d1945e9dfd063f48"
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
                sh './gradlew docker'
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
        stage('Deploy to AWS') {
            environment {
                DOCKER_HUB_LOGIN = credentials('docker-hub')
            }
            steps {
                withAWS(credentials: 'awscredential', region: env.AWS_REGION) {
                    sh './gradlew awsCfnMigrateStack awsCfnWaitStackComplete -PsubnetId=${SUBNET_ID} -Pvpcid=${VPCID} -PdockerHubUsername=$DOCKER_HUB_LOGIN_USR -Pregion=${AWS_REGION}'
                }
            }
        }
    }
}