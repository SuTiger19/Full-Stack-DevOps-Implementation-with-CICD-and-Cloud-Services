



#! /bin/bash
sudo yum install -y docker
sudo service docker start
export ECR=494992235231.dkr.ecr.us-east-1.amazonaws.com/
export DBECR=$ECR/database-image-docker-assignment:v0.1
export APPECR=$ECR/app-image-docker-assignment:v0.1
export DBPORT=3306
export DBUSER=root
export DATABASE=employees
export DBPWD=pw
aws ecr get-login-password --region us-east-1 |sudo docker login -u AWS ${ECR} --password-stdin   
sudo docker pull $DBECR
sudo docker pull $APPECR
sudo docker network create customBridge
sudo docker run --name mysql-db --network=customBridge -d -e MYSQL_ROOT_PASSWORD=pw $DBECR
export DBHOST=$(sudo docker inspect --format '{{ .NetworkSettings.Networks.customBridge.IPAddress }}' mysql-db)
sleep 40
export APP_COLOR=blue
sudo docker run -d --name blue -p 8081:8080  --network=customBridge -e APP_COLOR=$APP_COLOR -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD $APPECR
export APP_COLOR=green
sudo docker run -d --name lime -p 8082:8080  --network=customBridge -e APP_COLOR=$APP_COLOR -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD $APPECR
export APP_COLOR=pink
sudo docker run -d --name pink -p 8083:8080  --network=customBridge -e APP_COLOR=$APP_COLOR -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD $APPECR


#! /bin/bash

# Install Docker
sudo yum install -y docker
sudo service docker start

# Install AWS CLI v2 (if not already installed)
if ! command -v aws &> /dev/null
then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
fi

# Environment variables based on the GitHub Actions workflow
ECR_REGION="us-east-1"
DATABASE_ECR_PREFIX="database-image-docker-assignment"
APPLICATION_ECR_PREFIX="app-image-docker-assignment"
ECR_REPOSITORY="docker-assignment"
IMAGE_TAG="v0.1"

# Construct ECR repository URLs
ECR_REGISTRY="$(aws sts get-caller-identity --query Account --output text).dkr.ecr.${ECR_REGION}.amazonaws.com"
DBECR="${ECR_REGISTRY}/${DATABASE_ECR_PREFIX}:${IMAGE_TAG}"
APPECR="${ECR_REGISTRY}/${APPLICATION_ECR_PREFIX}:${IMAGE_TAG}"


# Login to Amazon ECR
aws ecr get-login-password --region ${ECR_REGION} | sudo docker login --username AWS --password-stdin ${ECR_REGISTRY}

# Pull the Docker images
sudo docker pull ${DBECR}
sudo docker pull ${APPECR}

# Create a Docker network
sudo docker network create customBridge

# Run the database container
sudo docker run --name mysql-db --network=customBridge -d -e MYSQL_ROOT_PASSWORD=pw ${DBECR}

# Wait for the database to initialize
sleep 40

# Run application containers with different colors
declare -a COLORS=("blue" "green" "pink")
PORT=8081

for COLOR in "${COLORS[@]}"; do
    APP_CONTAINER_NAME="${COLOR}-app"
    DBHOST=$(sudo docker inspect --format '{{ .NetworkSettings.Networks.customBridge.IPAddress }}' mysql-db)
    
    sudo docker run -d --name ${APP_CONTAINER_NAME} -p ${PORT}:8080 --network=customBridge \
        -e APP_COLOR=${COLOR} -e DBHOST=${DBHOST} -e DBPORT=3306 -e DBUSER=root -e DBPWD=pw ${APPECR}
    
    ((PORT++))
done





#!/bin/bash

yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 494992235231.dkr.ecr.us-east-1.amazonaws.com


docker network create --driver bridge Sudeep-network

docker pull 494992235231.dkr.ecr.us-east-1.amazonaws.com/app-image-docker-assignment:v0.1
docker pull 494992235231.dkr.ecr.us-east-1.amazonaws.com/database-image-docker-assignment:v0.1

docker run -d --network=Sudeep-network --name=db_container -e MYSQL_ROOT_PASSWORD=pw 494992235231.dkr.ecr.us-east-1.amazonaws.com/database-image-docker-assignment:v0.1

# Extract the database host IP
DBHOST=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(docker ps -q -f ancestor=494992235231.dkr.ecr.us-east-1.amazonaws.com/database-image-docker-assignment:v0.1))



docker run -d --network=Sudeep-network -p 8081:8080 -e DBHOST=$DBHOST -e DBPORT=3306 -e DBUSER=root -e DATABASE=employees -e DBPWD=pw -e APP_COLOR=blue 494992235231.dkr.ecr.us-east-1.amazonaws.com/app-image-docker-assignment:v0.1
docker run -d --network=Sudeep-network -p 8082:8080 -e DBHOST=$DBHOST -e DBPORT=3306 -e DBUSER=root -e DATABASE=employees -e DBPWD=pw -e APP_COLOR=pink 494992235231.dkr.ecr.us-east-1.amazonaws.com/app-image-docker-assignment:v0.1
docker run -d --network=Sudeep-network -p 8083:8080 -e DBHOST=$DBHOST -e DBPORT=3306 -e DBUSER=root -e DATABASE=employees -e DBPWD=pw -e APP_COLOR=lime 494992235231.dkr.ecr.us-east-1.amazonaws.com/app-image-docker-assignment:v0.1



