#!/bin/bash

# Grafana Alloy and LGTM Setup Script for Kind Kubernetes
# This script helps you deploy and manage observability stack

KUBECONFIG_PATH="$(pwd)/kubeconfig"


echo "🚀 Deploying observability stack..."

echo "📊 Deploying LGTM stack..."
kubectl --kubeconfig "$KUBECONFIG_PATH" apply -f observability/lgtm.yaml

echo "📈 Deploying kube-state-metrics..."
kubectl --kubeconfig "$KUBECONFIG_PATH" apply -f observability/kube-state-metrics.yaml

echo "🔍 Deploying Grafana Alloy..."
kubectl --kubeconfig "$KUBECONFIG_PATH" apply -f observability/alloy.yaml


echo ""
echo "⏳ Waiting for deployments to be ready..."
echo "LGTM stack:"
kubectl --kubeconfig "$KUBECONFIG_PATH" wait --for=condition=available --timeout=300s deployment/lgtm

echo "kube-state-metrics:"
kubectl --kubeconfig "$KUBECONFIG_PATH" wait --for=condition=available --timeout=300s deployment/kube-state-metrics -n kube-system

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Access the observability stack:"
echo "  🎨 Grafana: http://localhost/lgtm/"