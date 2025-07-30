#!/bin/bash

set -e

echo "🚀 Setting up Kind cluster with ingress..."

# Create the cluster
echo "📦 Creating Kind cluster..."
kind create cluster --config=kind-config.yaml --kubeconfig $(pwd)/kubeconfig

# Wait for cluster to be ready
echo "⏳ Waiting for cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s --kubeconfig $(pwd)/kubeconfig

# Install NGINX Ingress Controller
echo "🔧 Installing NGINX Ingress Controller..."
kubectl apply -f kind-nginx-ingress.yaml --kubeconfig $(pwd)/kubeconfig

# Wait for ingress controller to be ready
echo "⏳ Waiting for NGINX Ingress Controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s \
  --kubeconfig $(pwd)/kubeconfig

echo "✅ Kind cluster with ingress is ready!"