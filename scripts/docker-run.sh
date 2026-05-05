#!/bin/bash
set -e

echo "Starting MuchToDo application with Docker Compose..."
docker compose down
docker compose up --build -d
echo "Waiting for services to be healthy..."
sleep 10
docker compose ps
echo "Application is running!"
echo "Backend API: http://localhost:8080"
echo "Health Check: http://localhost:8080/health"
echo "API Docs: http://localhost:8080/swagger/index.html"
