pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID="680032936053" //aws account ID to be used
        AWS_DEFAULT_REGION="us-east-1"
        IMAGE_REPO_NAME="spring-boot-api-example"
        IMAGE_TAG="${env.BUILD_ID}"
        SUBNET_ID="" //create a vpc and subnet and provide that value
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
        registryCredential = "CHANGE_ME" //aws credentials
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
                script {
                    dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                }
                //sh './gradlew docker'
            }
        }
        stage('Push Docker image') {
            steps{  
                script {
			        docker.withRegistry("https://" + REPOSITORY_URI, "ecr:${AWS_DEFAULT_REGION}:" + registryCredential) 
                    {
                    	dockerImage.push()
                	}
                }
            }
            //environment {
                //DOCKER_HUB_LOGIN = credentials('docker-hub')
            //}
            //steps {
                //sh 'docker login --username=$DOCKER_HUB_LOGIN_USR --password=$DOCKER_HUB_LOGIN_PSW'
                //sh './gradlew dockerPush -PdockerHubUsername=$DOCKER_HUB_LOGIN_USR'
            //}
        }
        stage('Deploy to AWS') {
            //environment {
                //DOCKER_HUB_LOGIN = credentials('docker-hub')
            //}
            steps {
                withAWS(credentials: 'aws-credentials', region: env.AWS_REGION) {
                    sh './gradlew awsCfnMigrateStack awsCfnWaitStackComplete -PsubnetId=${SUBNET_ID} -PdockerImageName=${IMAGE_REPO_NAME} -PdockerImageTag=${IMAGE_TAG} -Pregion=${AWS_DEFAULT_REGION}'
                }
            }
        }
    }
}
