# NGINX Kubernetes Deployment on AWS (EKS)

This repository contains Kubernetes manifests and instructions to deploy an NGINX application on an AWS EKS cluster using `kubectl` or ArgoCD.

---

## Contents

- [Prerequisites](#prerequisites)  
- [1. Provision an EKS Cluster on AWS](#1-provision-an-eks-cluster-on-aws)  
- [2. Install ArgoCD on EKS (Optional)](#2-install-argocd-on-eks-optional)  
- [3. Deploy NGINX Application](#3-deploy-nginx-application)  
- [4. Access NGINX Application](#4-access-nginx-application)  
- [5. (Optional) Setup Ingress with AWS ALB Ingress Controller](#5-optional-setup-ingress-with-aws-alb-ingress-controller)  
- [Summary of Access Methods on AWS](#summary-of-access-methods-on-aws)  
- [Notes](#notes)  
- [License](#license)

---

## Prerequisites

- AWS CLI installed and configured with sufficient permissions (https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- `eksctl` CLI installed (https://eksctl.io/introduction/#installation)
- `kubectl` CLI installed (https://kubernetes.io/docs/tasks/tools/)
- (Optional) `argocd` CLI installed for managing ArgoCD from command line (https://argo-cd.readthedocs.io/en/stable/cli_installation/)

---

## 1. Provision an EKS Cluster on AWS

### Step 1: Create an EKS Cluster using eksctl

Run the following command to create an EKS cluster with a managed node group:

```bash
eksctl create cluster \
  --name nginx-eks-cluster \
  --version 1.27 \
  --region us-west-2 \
  --nodegroup-name standard-workers \
  --node-type t3.medium \
  --nodes 3 \
  --nodes-min 2 \
  --nodes-max 4 \
  --managed

---

## 🔐 ArgoCD Login Instructions

### ✅ Prerequisites

* Access to the ArgoCD server (URL/IP)
* ArgoCD CLI installed ([Install guide](https://argo-cd.readthedocs.io/en/stable/cli_installation/))
* Username & password or access token (depends on your setup)

---

### 📥 Step 1: Install ArgoCD CLI (if not already installed)

**macOS (Homebrew):**

```bash
brew install argocd
```

**Linux:**

```bash
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x argocd
sudo mv argocd /usr/local/bin/
```

---

### 🌐 Step 2: Login to ArgoCD

```bash
argocd login <ARGOCD_SERVER> --username <USERNAME> --password <PASSWORD> --insecure
```

* Replace `<ARGOCD_SERVER>` with your ArgoCD UI URL (e.g. `argocd.example.com`)
* Use `--insecure` if your ArgoCD server uses a self-signed certificate

✅ Example:

```bash
argocd login argocd.example.com --username admin --password YourPassword123 --insecure
```

---

### 🔑 Optional: Login Using a Token

```bash
argocd login <ARGOCD_SERVER> --auth-token <TOKEN> --insecure
```

---

### ✅ Step 3: Confirm Login

```bash
argocd account get-user-info
```

## 🌐 Accessing NGINX

You can access the NGINX service either locally (via port-forward) or publicly (if exposed via LoadBalancer or Ingress).

---

### 🔁 Option 1: Access via Port-Forward (Local Access)

This is useful for local testing or development without exposing the service publicly.

```bash
kubectl port-forward svc/<nginx-service-name> 8080:80
```

✅ Example:

```bash
kubectl port-forward svc/nginx-service 8080:80
```

Then open in browser:
[http://localhost:8080](http://localhost:8080)

---

### 🌍 Option 2: Access via Public URL (Ingress or LoadBalancer)

#### ✅ If using LoadBalancer:

```bash
kubectl get svc <nginx-service-name> -o wide
```

Look for the `EXTERNAL-IP` field:

```
NAME             TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)        AGE
nginx-service    LoadBalancer   10.0.0.1       203.0.113.100    80:30385/TCP   5m
```

Access via:
[http://203.0.113.100](http://203.0.113.100)

---

#### ✅ If using Ingress (e.g., with NGINX Ingress Controller):

Make sure an Ingress resource is defined:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
spec:
  rules:
    - host: nginx.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nginx-service
                port:
                  number: 80
```

1. Update your DNS to point `nginx.example.com` to the Ingress controller's IP
2. Access via: [http://nginx.example.com](http://nginx.example.com)

---

### 🔒 TLS (Optional)

To enable HTTPS (TLS), use a certificate manager like [cert-manager](https://cert-manager.io) and configure the Ingress with a TLS block.

