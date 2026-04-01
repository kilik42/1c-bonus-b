# Armageddon Labs 2026

A cloud infrastructure and distributed systems project demonstrating AWS deployment, networking, observability, and edge delivery using CloudFront and WAF.

---

## Deliverables

### 1A – EC2 + RDS Application

- [1A Deployment + App Proof](docs/1a_deliverables/1_a.pdf)

Highlights:
- EC2 instance running application
- RDS database connectivity
- API endpoints functional

---

### 1B – CloudWatch Monitoring

- [CloudWatch Agent Setup](docs/1b_deliverables/cloud%20watch%20agent%20running.pdf)

Highlights:
- CloudWatch agent installed on EC2
- Logs and metrics collection
- Observability pipeline validated

---

### 1C – Advanced Infrastructure (ALB + Route53 + Debugging)

- [Bonus C](docs/1c_deliverables/1%20c%20bonus%20c.pdf)

Highlights:
- Application Load Balancer configured
- Route53 domain mapping verified
- Target group debugging (health checks, timeouts)

Key Issue:
- Target group initially unhealthy (timeout issue)
- Required fixing backend service and networking

---

### 1C Bonus A – SSM + Private Infrastructure

- [Bonus A Outputs](docs/1c_deliverables/1C%20BONUS%20A%20OUTPUTS_DELIVERABLE.pdf)

Highlights:
- SSH-free access using SSM
- VPC endpoints for:
  - SSM
  - EC2 Messages
  - Secrets Manager
- Secure internal communication

---

### 1C Bonus B – VPC Deep Dive

- [Bonus B](docs/1c_deliverables/1c%20bonus%20B.pdf)

Highlights:
- Verified subnets, route tables, internet gateway, and NAT gateway
- Validated full VPC configuration

---

## Lab 2 – CloudFront, Caching, and API Routing

- [Lab 2A](docs/lab_2/lab%202a.pdf)
- [Lab 2B](docs/lab_2/2b_Be_A_Man.pdf)

This lab demonstrates:

- CloudFront distribution setup
- ALB as origin
- Static and API routing behavior
- Caching configuration

Evidence:

Initial failure:
- CloudFront returned 502/504 errors for both static and API endpoints  
- Example shown in logs → :contentReference[oaicite:0]{index=0}  

Root cause:
- ALB worked directly
- CloudFront to ALB failed
- Indicates origin connectivity or configuration issue

Validation:
- ALB returned successful responses
- CloudFront distribution confirmed
- DNS correctly pointed to CloudFront  

Configuration and validation steps → :contentReference[oaicite:1]{index=1}  

---

## Lab 3 – Multi-Region Terraform Infrastructure(still in development)

- [Lab 3A](docs/lab_3/lab%203a.pdf)

Highlights:

- Multi-region deployment:
  - São Paulo
  - Tokyo
- Separate Terraform configurations per region
- Includes VPC, subnets, ALB, ASG, and RDS

Repository structure evidence → :contentReference[oaicite:2]{index=2}  

---

## Technology Stack

- AWS: EC2, RDS, ALB, CloudFront, Route53, WAF, SSM
- Terraform
- Windows Server (IIS)
- Python APIs

---

## Key Skills Demonstrated

Infrastructure:
- VPC design (public and private subnets)
- NAT and routing
- Load balancing

Observability:
- CloudWatch logging and metrics

Security:
- SSM (no SSH access)
- VPC endpoints
- WAF integration

Edge and CDN:
- CloudFront caching
- Origin debugging
- DNS routing

DevOps:
- Infrastructure as Code with Terraform
- Multi-region deployment design

---

## Real-World Issues Solved

- Target group unhealthy due to connectivity issues
- CloudFront 504 errors caused by origin misconfiguration
- Endpoint routing issues with ALB listeners
- DNS validation and routing fixes

---

## Project Structure

```bash
docs/
├── 1a_deliverables/
├── 1b_deliverables/
├── 1c_deliverables/
├── lab_2/
├── lab_3/
├── 1c_bonus_d/
└── 1c_bonus_e/
