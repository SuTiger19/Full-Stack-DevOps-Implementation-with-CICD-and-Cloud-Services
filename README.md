# Full-Stack DevOps Implementation with CI/CD and Cloud Services

## Overview

This project demonstrates a comprehensive CI/CD pipeline that manages the full lifecycle of a Flask application—from image creation using GitHub Actions to deployment on Amazon Web Services (AWS) using Docker, Kubernetes, and Terraform.

## Technologies Used

- **Version Control:** Git
- **CI/CD:** GitHub Actions
- **Containerization:** Docker
- **Orchestration:** Kubernetes (K8s), AWS EKS, AWS ECS
- **Infrastructure as Code:** Terraform
- **Cloud Services:** AWS EKS, AWS ECS, AWS RDS, AWS RDS, AWS EC2, AWS FAREGATE
- **Load Balancing:** AWS Load Balancer
- **Database:** SQL (via AWS RDS and POD)
- **Security:** HTTPS

## Workflow Steps

### Part 1: Continuous Integration and Docker Image Creation

1. **Setup GitHub Actions:** Configure actions to automatically perform unit tests and build Docker images for both the frontend and SQL backend of the Flask application.
2. **Image Repository:** Push the created images to Amazon Elastic Container Registry (ECR) for secure storage and version control.

### Part 2: Infrastructure Setup Using Terraform

1. **Initialize Terraform:** Automate the setup of AWS infrastructure, starting with a basic EC2 instance.
2. **Docker Configuration:** Execute scripts via Terraform to install and start Docker on the EC2 instance.
3. **Networking:** Create a Docker bridge network to facilitate communication between containers.
4. **Container Deployment:** Pull the Docker images from ECR and deploy the database followed by the application on the configured EC2 instance.

### Part 3: Local Kubernetes Development Using Kind

1. **Kind Cluster:** Utilize Terraform to install a Kind cluster, a tool that runs local Kubernetes clusters using Docker container "nodes".
2. **Deployments:** Apply Kubernetes manifests to deploy the SQL database and the Flask application within the Kind environment.

### Part 4: Production Deployment on AWS EKS

1. **EKS Configuration:** Use Terraform to provision an AWS EKS cluster.
2. **Cluster Management:** Deploy the Flask application across multiple worker nodes using Kubernetes secrets, config-maps, and Flux for automatic updates and rollbacks.

### Part 5: Scalable Deployment Using AWS ECS

1. **ECS Configuration:** Configure the deployment of the Flask application on AWS ECS using the Fargate launch type for serverless operation.
2. **Database Integration:** Utilize AWS RDS for the SQL database to ensure durability and scalability.
3. **Load Balancing:** Implement AWS Load Balancer to distribute traffic efficiently to the application, enhancing reliability and performance.

## Conclusion

This project exemplifies a robust DevOps pipeline that integrates multiple technologies to deliver a scalable, secure, and highly available application on AWS. Each component is configured to ensure best practices in continuous integration, container management, and cloud-native deployment.

