# Kubernetes Local Infrastructure with Observability

This repository contains a complete local Kubernetes development environment with observability stack using Kind, LGTM (Loki, Grafana, Tempo, Mimir), and Grafana Alloy.

## 🏗️ Architecture

```
┌─────────────────────┐    ┌─────────────────────┐    ┌─────────────────────┐
│                     │    │                     │    │                     │
│   Grafana Alloy     │───▶│    LGTM Stack       │◄──▶│     Grafana UI      │
│   (Data Collector)  │    │                     │    │   (Visualization)   │
│                     │    │  • Loki (Logs)      │    │                     │
│  • Metrics          │    │  • Tempo (Traces)   │    │  http://localhost/  │
│  • Logs             │    │  • Prometheus       │    │         lgtm/       │
│  • Traces           │    │  • Pyroscope        │    │                     │
│  • Profiles         │    │                     │    │                     │
└─────────────────────┘    └─────────────────────┘    └─────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        Kubernetes Cluster (Kind)                            │
│                                                                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐            │
│  │   Demo Apps     │  │ kube-state-     │  │   Your Apps     │            │
│  │                 │  │   metrics       │  │                 │            │
│  │ • nginx         │  │                 │  │ • Custom apps   │            │
│  │ • Annotated     │  │ • Cluster       │  │ • Microservices │            │
│  │   for metrics   │  │   metrics       │  │ • Workloads     │            │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘            │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- Docker installed and running
- Kind installed ([installation guide](https://kind.sigs.k8s.io/docs/user/quick-start/#installation))
- kubectl installed

### 1. Set up the Kubernetes cluster

```bash
# Create Kind cluster with ingress support
./setup-cluster.sh

# Wait for cluster to be ready
kubectl --kubeconfig $(pwd)/kubeconfig get nodes
```

### 2. Deploy the observability stack

```bash
# Deploy everything (LGTM, Alloy, kube-state-metrics, demo apps)
./observability.sh
```

### 3. Access the applications

- **Grafana**: http://localhost/lgtm/ (admin/admin)
- **Demo App**: http://localhost/demo , http://localhost/hello, http://localhost/echo

## 📊 What Gets Collected

### Metrics
- **Kubernetes cluster metrics**: CPU, memory, network, storage from kubelet and cAdvisor
- **Cluster state metrics**: Deployments, pods, services, ingresses from kube-state-metrics
- **Application metrics**: From pods with `prometheus.io/scrape: "true"` annotation

### Logs
- **Container logs**: All pod logs from all namespaces
- **System logs**: Kubernetes component logs
- **Application logs**: Structured and unstructured logs

### Traces
- **OTLP traces**: Applications can send traces to Alloy on ports 4317 (gRPC) and 4318 (HTTP)
- **Automatic correlation**: Traces are linked with logs and metrics

### Profiles (Optional)
- **Go applications**: CPU and memory profiling for applications with `pyroscope.io/scrape: "true"` annotation

## 🔧 Configuration

### Instrumenting Your Applications

#### For Prometheus Metrics
Add these annotations to your pod spec:

```yaml
metadata:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8080"      # Your metrics port
    prometheus.io/path: "/metrics"  # Your metrics endpoint
```

#### For OpenTelemetry Traces
Configure your application to send traces to:
- **gRPC**: `http://alloy.default.svc.cluster.local:4317`
- **HTTP**: `http://alloy.default.svc.cluster.local:4318`

#### For Pyroscope Profiles (Go apps)
Add these annotations:

```yaml
metadata:
  annotations:
    pyroscope.io/scrape: "true"
    pyroscope.io/port: "8080"
    pyroscope.io/path: "/debug/pprof"
```

