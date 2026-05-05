#!/bin/bash
set -e

echo "Deploying MuchToDo to Kubernetes..."

echo "Creating namespace..."
kubectl apply -f kubernetes/namespace.yaml

echo "Deploying MongoDB..."
kubectl apply -f kubernetes/mongodb/mongodb-secret.yaml
kubectl apply -f kubernetes/mongodb/mongodb-configmap.yaml
kubectl apply -f kubernetes/mongodb/mongodb-pvc.yaml
kubectl apply -f kubernetes/mongodb/mongodb-deployment.yaml
kubectl apply -f kubernetes/mongodb/mongodb-service.yaml

echo "Waiting for MongoDB to be ready..."
kubectl wait --for=condition=ready pod -l app=mongodb -n muchtodo --timeout=120s

echo "Deploying Backend..."
kubectl apply -f kubernetes/backend/backend-secret.yaml
kubectl apply -f kubernetes/backend/backend-configmap.yaml
kubectl apply -f kubernetes/backend/backend-env-configmap.yaml
kubectl apply -f kubernetes/backend/backend-deployment.yaml
kubectl apply -f kubernetes/backend/backend-service.yaml

echo "Deploying Ingress..."
kubectl apply -f kubernetes/ingress.yaml

echo "Waiting for backend to be ready..."
kubectl wait --for=condition=ready pod -l app=muchtodo-backend -n muchtodo --timeout=120s

echo "Deployment complete!"
echo ""
kubectl get all -n muchtodo
echo ""
echo "Access the app via port-forward:"
echo "kubectl port-forward service/backend-service 8080:8080 -n muchtodo"
