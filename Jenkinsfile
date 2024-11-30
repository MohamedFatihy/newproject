pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = '<your-aws-account-id>'
        AWS_REGION = 'us-west-2'
        ECR_REPO = 'my-app-repo'
        EKS_CLUSTER_NAME = 'my-eks-cluster'
        DOCKER_IMAGE = 'my-app'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/your-username/your-repo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
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
                    // Tag the image and push to ECR
                    sh "docker tag ${DOCKER_IMAGE}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest"
                    sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest"
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    // Use kubectl to deploy to EKS
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
