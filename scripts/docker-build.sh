#!/bin/bash
set -e

echo "Building MuchToDo Docker image..."
docker build -t muchtodo-backend:latest .
echo "Tagging image for Docker Hub..."
docker tag muchtodo-backend:latest viviecodes/muchtodo-backend:latest
echo "Pushing image to Docker Hub..."
docker push viviecodes/muchtodo-backend:latest
echo "Docker build and push completed successfully!"
