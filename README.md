# MuchToDo - Containerization Assessment

## Overview
MuchToDo is a Golang REST API containerized with Docker and deployed to Kubernetes. It connects to MongoDB for data storage and Redis for caching.

## Project Structure
\\\
much-to-do/
├── Server/MuchToDo/          # Golang application source code
├── Dockerfile                # Multi-stage Docker build
├── docker-compose.yml        # Local development setup
├── .dockerignore             # Docker build exclusions
├── kubernetes/
│   ├── namespace.yaml        # Kubernetes namespace
│   ├── mongodb/              # MongoDB manifests
│   │   ├── mongodb-secret.yaml
│   │   ├── mongodb-configmap.yaml
│   │   ├── mongodb-pvc.yaml
│   │   ├── mongodb-deployment.yaml
│   │   └── mongodb-service.yaml
│   ├── backend/              # Backend manifests
│   │   ├── backend-secret.yaml
│   │   ├── backend-configmap.yaml
│   │   ├── backend-env-configmap.yaml
│   │   ├── backend-deployment.yaml
│   │   └── backend-service.yaml
│   └── ingress.yaml          # Ingress configuration
├── scripts/
│   ├── docker-build.sh       # Build and push Docker image
│   ├── docker-run.sh         # Run with Docker Compose
│   ├── k8s-deploy.sh         # Deploy to Kubernetes
│   └── k8s-cleanup.sh        # Clean up Kubernetes resources
├── evidence/                 # Screenshots of deployment
└── README.md
\\\

## Prerequisites
- Docker Desktop (with Kubernetes enabled)
- kubectl
- Git

## Application Details
- **Language:** Golang
- **Framework:** Gin
- **Database:** MongoDB (with Replica Set)
- **Cache:** Redis
- **Port:** 8080

## Phase 1: Docker Setup

### Build the Docker Image
\\\ash
bash scripts/docker-build.sh
\\\
Or manually:
\\\ash
docker build -t muchtodo-backend:latest .
\\\

### Run with Docker Compose
\\\ash
bash scripts/docker-run.sh
\\\
Or manually:
\\\ash
docker compose up --build -d
\\\

### Services
| Service | URL |
|---|---|
| Backend API | http://localhost:8080 |
| Health Check | http://localhost:8080/health |
| API Docs (Swagger) | http://localhost:8080/swagger/index.html |
| MongoDB | localhost:27017 |
| Redis | localhost:6379 |

### Stop Docker Compose
\\\ash
docker compose down
\\\

## Phase 2: Kubernetes Deployment

### Deploy to Kubernetes
\\\ash
bash scripts/k8s-deploy.sh
\\\
Or manually:
\\\ash
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/mongodb/
kubectl apply -f kubernetes/backend/
kubectl apply -f kubernetes/ingress.yaml
\\\

### Check Deployment Status
\\\ash
kubectl get all -n muchtodo
\\\

### Access the Application
\\\ash
kubectl port-forward service/backend-service 8080:8080 -n muchtodo
\\\
Then visit: http://localhost:8080/health

### Kubernetes Resources
| Resource | Details |
|---|---|
| Namespace | muchtodo |
| MongoDB Replicas | 1 |
| Backend Replicas | 2 |
| Backend Service | NodePort :30080 |
| MongoDB Service | ClusterIP :27017 |

### Clean Up Kubernetes Resources
\\\ash
bash scripts/k8s-cleanup.sh
\\\

## API Endpoints
| Method | Endpoint | Description |
|---|---|---|
| GET | /health | Health check |
| GET | /ping | Ping endpoint |
| POST | /auth/login | User login |
| GET | /users | Get all users |
| POST | /users | Create user |
| GET | /users/:id | Get user by ID |
| PUT | /users/:id | Update user |
| DELETE | /users/:id | Delete user |
| GET | /posts | Get all posts |
| POST | /posts | Create post |

## Environment Variables
| Variable | Description | Default |
|---|---|---|
| PORT | Server port | 8080 |
| MONGO_URI | MongoDB connection string | - |
| DB_NAME | Database name | much_todo_db |
| JWT_SECRET_KEY | JWT signing key | - |
| JWT_EXPIRATION_HOURS | Token expiry | 72 |
| ENABLE_CACHE | Enable Redis cache | false |
| REDIS_ADDR | Redis address | - |
| LOG_LEVEL | Log level | INFO |
| LOG_FORMAT | Log format | json |

## Docker Image
The image is available on Docker Hub:
\\\ash
docker pull viviecodes/muchtodo-backend:latest
\\\

## Dockerfile Details
- **Multi-stage build** for optimized image size
- **Base image:** golang:1.25-alpine (builder)
- **Runtime image:** alpine:3.19
- **Non-root user:** appuser
- **Health check:** GET /health every 30s
