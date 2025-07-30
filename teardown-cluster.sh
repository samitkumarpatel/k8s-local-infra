#!/bin/bash

set -e

echo "🧹 Tearing down Kind cluster..."

# Delete the cluster
kind delete cluster --name local-cluster

echo "✅ Kind cluster 'local-cluster' has been deleted!" 