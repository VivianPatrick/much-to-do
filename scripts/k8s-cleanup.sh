#!/bin/bash
set -e

echo "Cleaning up MuchToDo Kubernetes resources..."

echo "Deleting backend resources..."
kubectl delete -f kubernetes/backend/ -n muchtodo --ignore-not-found=true

echo "Deleting MongoDB resources..."
kubectl delete -f kubernetes/mongodb/ -n muchtodo --ignore-not-found=true

echo "Deleting ingress..."
kubectl delete -f kubernetes/ingress.yaml --ignore-not-found=true

echo "Deleting namespace..."
kubectl delete -f kubernetes/namespace.yaml --ignore-not-found=true

echo "Cleanup complete!"
