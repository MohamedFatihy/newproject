pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = '861276114611'
        AWS_REGION = 'us-west-2'
        ECR_REPO = 'my-app-repo'
        EKS_CLUSTER_NAME = 'my-eks-cluster'
        DOCKER_IMAGE = 'my-app'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/MohamedFatihy/newproject.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build("$DOCKER_IMAGE", ".")
                }
            }
        }

        stage('Login to AWS ECR') {
            steps {
                script {
                    // Login to AWS ECR
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                }
            }
        }

        stage('Push to AWS ECR') {
            steps {
                script {
                    // Tag the Docker image and push to AWS ECR
                    sh "docker tag ${DOCKER_IMAGE}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest"
                    sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest"
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    // Use kubectl to deploy to the EKS cluster
                    sh "kubectl set image deployment/nginx-deployment nginx=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest --record"
                    sh "kubectl rollout status deployment/nginx-deployment"
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
