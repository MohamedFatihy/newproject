This project focuses on automating the process of building, testing, and deploying a Dockerized application on AWS using a CI/CD pipeline in Jenkins. The pipeline orchestrates the entire process, from pulling the latest code to deploying it on AWS EKS. Here's a concise overview of the components, stages, tools, and workflow involved:
Key Components:

   - AWS ECR (Elastic Container Registry): A secure, scalable service for storing Docker images.
   - AWS EKS (Elastic Kubernetes Service): Hosts the Kubernetes cluster where the Dockerized application will be deployed and run.
   - Jenkins: Automates the CI/CD pipeline to facilitate continuous integration and deployment, from code push to application deployment.

Pipeline Stages:

   - Clone Repository: Jenkins pulls the latest code from the GitHub repository.
   - Build Docker Image: The pipeline builds the Docker image based on the Dockerfile.
   - Login to AWS ECR: Jenkins authenticates with AWS ECR using AWS CLI to allow the image push.
   - Push to AWS ECR: The Docker image is tagged and pushed to AWS ECR for storage.
   - Deploy to EKS: The pipeline uses kubectl to deploy the Docker image to a Kubernetes deployment in AWS EKS.

Tools Used:

   - Docker: Used to containerize the application.
   - AWS ECR: Stores the Docker images in a scalable and secure environment.
   - AWS EKS: Hosts the Kubernetes cluster for application deployment.
   - Jenkins: Automates the end-to-end CI/CD pipeline.
   - kubectl: Interacts with Kubernetes resources on EKS to deploy the application.

Workflow:

   - Code Commit: Developers push updates to the GitHub repository.
   - Jenkins Trigger: The pipeline is automatically triggered by changes in the repository.
   - Build & Push: Jenkins builds the Docker image and uploads it to AWS ECR.
   - Deploy: Jenkins deploys the latest Docker image to the EKS cluster, ensuring the application is up-to-date.
