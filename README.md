# Armageddon Labs 2026

This is my running log of everything I built for the Armageddon Labs project: EC2, RDS, ALB, CloudFront, WAF, SSM, and all the debugging that came with it. Each section links to the screenshots/PDFs I submitted as proof of the work. Nothing fancy, just what I actually deployed and validated.

-----

> ### ⚠️ **Important: Python Validation Evidence**
>
> All infrastructure in this repository was programmatically verified using Python scripts. **The terminal outputs, script logs, and validation screenshots are located at the end of each PDF document listed below.**

-----

## Lab Evidence & Validation

Instead of manual screenshots alone, I used Python scripts to validate the state of the infrastructure. The documentation below contains the terminal outputs, script logs, and visual evidence of these automated checks.

## Python Evidence of Lab 1, Lab 2, and Lab 3

Instead of manual screenshots alone, I used Python scripts to validate the state of the infrastructure. This directory contains the terminal outputs, script logs, and visual evidence of these automated checks.

### Lab 1: Infrastructure and Security Validation

Validation scripts were used to audit the initial stack deployment:

  * **Lab 1A (EC2/RDS Core):** Python scripts verified the ALB DNS (`tetsuzai-kube.com`) and confirmed that the `/init`, `/add`, and `/list` endpoints were reachable and returning data.
      * [View Lab 1A Evidence](https://www.google.com/search?q=./LABS%2520Redone%2520with%2520python%2520evidence/Lab_1_Redone/LAB_1A_Redone/lab1a_redone_deliverables_evidence.pptx)
  * **Lab 1B (Monitoring & SNS):** Verified SNS notification flow. Tested by programmatically monitoring CloudWatch alarm states while simulating a target group failure.
      * [View Lab 1B Evidence](https://www.google.com/search?q=./LABS%2520Redone%2520with%2520python%2520evidence/Lab_1_Redone/LAB_1B_REDONE/LAB%25201B%2520Redone.pptx)
  * **Lab 1C (WAF Security):** Confirmed that AWS WAF was correctly associated with the ALB and filtering traffic via managed rule groups.
      * [View Lab 1C Evidence](https://www.google.com/search?q=./LABS%2520Redone%2520with%2520python%2520evidence/Lab_1_Redone/Lab_1C_Redone/Lab%25201C%2520redone.pptx)

### Lab 2: Edge Delivery and SSL Validation

For the CloudFront rollout, I used Python to verify caching and routing logic:

  * **Cache-Routing Audit:** Ran a validation script to ensure all three header checks passed, confirming that the CloudFront distribution was handling dynamic and static content correctly.
  * **HTTPS/SSL Verification:** Programmatically verified the SSL handshake and certificate validity for the custom domain.
  * [View Lab 2 Evidence](https://www.google.com/search?q=./LABS%2520Redone%2520with%2520python%2520evidence/Lab_2_Redone/lab2%2520evidence.pptx)

### Lab 3: Multi-Region Networking

Evidence covering the setup and attachment of Transit Gateways (TGW) across regions:

  * **TGW Validation:** Terminal logs show the successful attachment IDs for both the "primary" and "saopaulo" regions.
  * [View Lab 3 Evidence](https://www.google.com/search?q=./LABS%2520Redone%2520with%2520python%2520evidence/Lab_3_redone/evidence.pptx)

-----

## Technology Stack

  * AWS: EC2, RDS, ALB, CloudFront, Route53, WAF, SSM, Transit Gateway
  * Automation: Python (Infrastructure Validation & Testing)
  * IaC: Terraform
  * OS/App: Windows Server (IIS), Python-based APIs

-----

## Troubleshooting and Issue Resolution

  * **CloudFront 504s:** Debugged origin timeout issues by validating ALB listener responses directly before testing through the CDN.
  * **Target Group Health:** Resolved connectivity issues between the ALB and EC2 instances by auditing security group ingress rules.
  * **SSM Integration:** Established secure management access via VPC endpoints, removing the need for SSH/RDP open to the internet.

-----

## Project Structure

```bash
.
├── README.md
└── LABS Redone with python evidence/
    ├── Lab_1_Redone/
    │   ├── LAB_1A_Redone/
    │   ├── LAB_1B_REDONE/
    │   └── Lab_1C_Redone/
    ├── Lab_2_Redone/
    ├── Lab_3_redone/
    └── notes.docx
```

---

## Old  Deliverables (in the docs folder) / This space below shows only cli evidence and aws console evidence. The python evidence is up above.

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
- Example shown in logs

Root cause:
- ALB worked directly
- CloudFront to ALB failed
- Indicates origin connectivity or configuration issue

Validation:
- ALB returned successful responses
- CloudFront distribution confirmed
- DNS correctly pointed to CloudFront  

Configuration and validation steps 

---

## Lab 3 – Multi-Region Terraform Infrastructure(still in development/ completed with my group)

- [Lab 3A](docs/lab_3/lab%203a.pdf)

Highlights:

- Multi-region deployment:
  - São Paulo
  - Tokyo
- Separate Terraform configurations per region
- Includes VPC, subnets, ALB, ASG, and RDS

Repository structure evidence 

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
