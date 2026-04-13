# AWS Hybrid Platform — Serverless + Container Platform

A production-grade hybrid platform mixing EKS containerised workloads with Lambda serverless functions, built to demonstrate senior-level DevOps engineering on AWS.

**Live API endpoint:** `https://pkzpdsbjya.execute-api.us-east-1.amazonaws.com/dev/hello`

---

## Tech Stack

| Category | Tool |
|---|---|
| CI/CD | Jenkins (on EKS) |
| IaC | Terraform (HCL) |
| Cloud | AWS (EKS, Lambda, S3, RDS, ECR) |
| Containers | Docker + Kubernetes (EKS) |
| Security | Trivy + OPA/Gatekeeper |
| Secrets | AWS Secrets Manager + HashiCorp Vault |
| Monitoring | Datadog |
| Networking | AWS VPC + Calico CNI |

---

## Architecture

```
GitHub Repository
       │
       ▼
Jenkins CI/CD (on EKS)
  ├── Trivy image scanning
  ├── OPA/Gatekeeper policy enforcement
  └── Deploy to EKS + Lambda
       │
       ├── EKS Cluster (private subnet)
       │   ├── Jenkins
       │   ├── HashiCorp Vault
       │   ├── Trivy operator
       │   └── OPA Gatekeeper
       │
       ├── Lambda Functions
       │   ├── S3 event processor
       │   └── API Gateway handler
       │
       └── RDS PostgreSQL (private subnet)

AWS Secrets Manager + Vault | Datadog observability
```

---

## What Makes It Senior-Level

- **Terraform modules with remote state** — S3 backend + DynamoDB locking prevents concurrent state corruption
- **OPA policy-as-code** — Gatekeeper enforces "no root containers" at Kubernetes admission level
- **Vault dynamic secrets** — credentials generated on-demand, never stored long-term
- **Hybrid architecture** — EKS long-running services + Lambda event-driven functions in the same VPC
- **Trivy scanning** — every image scanned for CVEs before deployment
- **Datadog observability** — full cluster visibility with logs and infrastructure metrics

---

## Infrastructure (Terraform IaC)

All AWS infrastructure defined as code. Single command deploys everything:

```bash
cd terraform/environments/dev
terraform init
terraform apply
```

Provisions: VPC with public/private subnets, EKS cluster, Lambda functions, API Gateway, S3 buckets, RDS PostgreSQL, ECR repository — all tagged and cost-tracked.

---

## Jenkins CI/CD on EKS

Jenkins runs as a pod inside the EKS cluster, accessible via AWS Load Balancer. Pipelines automate build, scan, and deploy on every push.

---

## Lambda — Serverless Functions

Two Lambda functions deployed via Terraform:

- **s3-processor** — triggered automatically on S3 file uploads
- **api-handler** — HTTP endpoint via API Gateway

Live response:
```json
{
  "message": "Hello from AWS Lambda on EKS Hybrid Platform!",
  "timestamp": "2026-04-13T22:49:05.549Z",
  "project": "hybrid-platform"
}
```

---

## Security Hardening

**OPA/Gatekeeper** — policy enforced at Kubernetes admission level, no containers may run as root.

**HashiCorp Vault** — secrets stored and rotated dynamically:
```bash
vault kv get secret/hybrid-platform/database
```

**AWS Secrets Manager** — static secrets synced from Vault for Lambda and RDS access.

---

## Datadog Observability

Datadog Agent deployed as DaemonSet on EKS. Monitors 21 pods across all namespaces, 3 worker nodes, CPU and memory usage, and all deployments including Jenkins, Vault, Trivy and Gatekeeper.

---

## Data Layer

RDS PostgreSQL deployed in private subnet — unreachable from the internet. Only accessible from within the VPC by EKS pods and Lambda functions. Credentials managed by HashiCorp Vault.

---

## Author

Khalid Hassan Osman