#!/bin/bash

# Log in to Docker Hub
docker login

# Ensure entrypoint.sh is executable
chmod +x Initiate.sh

# Build the Docker image with your Docker Hub username, repository, and tag
docker build -t minus1by12/sanatan:kerberos-1.0 .

# Push the Docker image to Docker Hub
docker push minus1by12/sanatan:kerberos-1.0

