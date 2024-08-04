#!/bin/bash

# Log in to Docker Hub
docker login

# Build the Docker image with your Docker Hub username, repository, and tag
docker build -t minus1by12/sanatan:phpldapadmin-1.0 .

# Push the Docker image to Docker Hub
docker push minus1by12/sanatan:phpldapadmin-1.0

