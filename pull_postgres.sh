#!/bin/bash

# Variables
AWS_REGION="us-west-2"
ECR_REPO_NAME="postgres"
DOCKER_IMAGE_NAME="postgres"
VERSION="16.3-alpine3.20"
POSTGRES_USER="root"
POSTGRES_PASSWORD="root"
POSTGRES_DB="root"
CONTAINER_NAME="postgres"
PORT="5432"

# Get AWS account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REPO_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME"

# Function to check if AWS CLI is installed
check_aws_cli() {
  if ! command -v aws &> /dev/null; then
    echo "AWS CLI could not be found. Please install AWS CLI."
    exit 1
  else
    echo "AWS CLI is installed."
  fi
}

# Authenticate Docker to ECR
authenticate_ecr() {
  echo "Authenticating Docker to ECR..."
  aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO_URI
  if [ $? -ne 0 ]; then
    echo "Docker login to ECR failed."
    exit 1
  fi
  echo "Docker authenticated to ECR successfully."
}

# Pull the Docker image from ECR
pull_docker_image() {
  echo "Pulling the Docker image from ECR..."
  docker pull $ECR_REPO_URI:$VERSION
  if [ $? -ne 0 ]; then
    echo "Failed to pull Docker image from ECR."
    exit 1
  fi
  echo "Docker image pulled successfully."
}

# Run the Docker container
run_docker_container() {
  echo "Running the Docker container..."
  docker run --name $CONTAINER_NAME \
    -e POSTGRES_USER=$POSTGRES_USER \
    -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
    -e POSTGRES_DB=$POSTGRES_DB \
    -p $PORT:5432 \
    -d $ECR_REPO_URI:$VERSION
  if [ $? -ne 0 ]; then
    echo "Failed to run Docker container."
    exit 1
  fi
  echo "Postgres database running with image: $ECR_REPO_URI:$VERSION"
}

# Main script execution
check_aws_cli
authenticate_ecr
pull_docker_image
run_docker_container
