#!/bin/bash

# Variables
AWS_REGION="us-west-2"
ECR_REPO_NAME="postgres"
DOCKER_IMAGE_NAME="postgres"
VERSION="16.3-alpine3.20"
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

# Build the Docker image
build_docker_image() {
  echo "Building the Docker image..."
  docker build -t $DOCKER_IMAGE_NAME:$VERSION .
  if [ $? -ne 0 ]; then
    echo "Docker build failed."
    exit 1
  fi
  echo "Docker image built successfully."
}

# Tag the Docker image
tag_docker_image() {
  echo "Tagging the Docker image..."
  docker tag $DOCKER_IMAGE_NAME:$VERSION $ECR_REPO_URI:$VERSION
  if [ $? -ne 0 ]; then
    echo "Docker tag failed."
    exit 1
  fi
  echo "Docker image tagged successfully."
}

# Push the Docker image to ECR
push_docker_image() {
  echo "Pushing the Docker image to ECR..."
  docker push $ECR_REPO_URI:$VERSION
  if [ $? -ne 0 ]; then
    echo "Docker push failed."
    exit 1
  fi
  echo "Docker image pushed to ECR: $ECR_REPO_URI:$VERSION"
}

# Main script execution
check_aws_cli
authenticate_ecr
build_docker_image
tag_docker_image
push_docker_image
