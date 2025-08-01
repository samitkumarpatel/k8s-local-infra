#!/bin/bash

# Grafana Alloy and LGTM Setup Script for Kind Kubernetes
# This script helps you deploy and manage observability stack

KUBECONFIG_PATH="$(pwd)/kubeconfig"


echo "🚀 Deploying observability stack..."

echo "📊 Deploying LGTM stack..."
kubectl --kubeconfig "$KUBECONFIG_PATH" delete -f observability/lgtm.yaml

echo "📈 Deploying kube-state-metrics..."
kubectl --kubeconfig "$KUBECONFIG_PATH" delete -f observability/kube-state-metrics.yaml

echo "🔍 Deploying Grafana Alloy..."
kubectl --kubeconfig "$KUBECONFIG_PATH" delete -f observability/alloy.yaml


echo ""
echo "⏳ Removed all observability components...."
