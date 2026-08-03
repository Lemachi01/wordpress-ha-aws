## Load Test Results

Tool: ApacheBench (ab)

Test:
- Requests: 1000
- Concurrent Users: 100

Results:
- Failed Requests: 0
- Requests/sec: 186.58
- Average Response Time: 535.955 ms

The Application Load Balancer successfully handled 1000 requests with 100 concurrent users without failures.
# WordPress High Availability AWS Deployment

## Project Overview

This project demonstrates a highly available WordPress deployment on AWS using Infrastructure as Code, containerization, monitoring, backup automation, and disaster recovery practices.

## Architecture Diagram

```
Internet
   |
Route 53 DNS
   |
Application Load Balancer (ALB)
   |
Auto Scaling Group
   |
EC2 Instances
   |
Docker Containers
   |
+----------------+
| Nginx          |
| WordPress      |
| MySQL          |
+----------------+

AWS Services:
- VPC
- Public/Private Subnets
- Application Load Balancer
- EC2 Auto Scaling
- RDS / MySQL Database
- S3 Backup Storage
- CloudWatch Monitoring
```

## Terraform Deployment

Infrastructure was provisioned using Terraform.

Terraform manages:

- VPC networking
- Subnets
- Security Groups
- EC2 instances
- Application Load Balancer
- IAM roles
- Monitoring resources
- Backup infrastructure

Deployment commands:

```bash
terraform init

terraform plan

terraform apply
```

Terraform state is stored remotely using:

- Amazon S3 backend
- DynamoDB state locking

## Docker Setup

The WordPress application runs using Docker containers.

Containers:

- Nginx reverse proxy
- WordPress application
- MySQL database

Docker Compose manages the local container deployment.

Example:

```bash
docker compose up -d
```

Container verification:

```bash
docker ps
```

## CI/CD Pipeline

GitHub Actions automates:

1. Code checkout
2. Application testing
3. Security scanning
4. Docker image validation
5. Deployment
6. Health checks
7. Rollback on failure

Pipeline workflow:

```
Git Push
   |
GitHub Actions
   |
Tests
   |
Security Scan
   |
Deploy
   |
Health Check
   |
Rollback if Failed
```

Security tools:

- Trivy
- WPScan

## Backup Strategy

Backups are automated using shell scripts.

Backup includes:

- WordPress files
- WordPress database
- Uploaded media
- Configuration data

Backup storage:

- Amazon S3

Backup command:

```bash
./scripts/backup.sh
```

Stored backups:

```
S3 Bucket
 |
 +-- Database backups
 |
 +-- WordPress file backups
```

## Monitoring

Monitoring is implemented using AWS CloudWatch.

Monitored resources:

- EC2 CPU utilization
- Memory usage
- Disk usage
- ALB health
- Application errors

CloudWatch alarms:

- CPU > 80%
- Memory > 80%
- Disk usage > 85%
- ALB 5XX errors
- Database storage alerts

## Load Test Results

Tool: ApacheBench (ab)

Test:

- Requests: 1000
- Concurrent Users: 100

Results:

- Failed Requests: 0
- Requests/sec: 186.58
- Average Response Time: 535.955 ms

The Application Load Balancer successfully handled 1000 requests with 100 concurrent users without failures.

## Disaster Recovery Plan

Recovery strategy:

1. Restore infrastructure using Terraform.

```bash
terraform apply
```

2. Restore WordPress files from Amazon S3.

3. Restore database backup.

4. Validate application health.

Recovery objectives:

- Infrastructure can be recreated automatically.
- Backups are stored separately in S3.
- Application availability is maintained through load balancing and auto scaling.

## Failover Testing

Test performed:

- Terminated EC2 instance manually.
- Verified Auto Scaling launched a replacement instance.
- Confirmed application remained available through ALB.

## Security

Implemented security controls:

- IAM least privilege access
- Security groups
- Private networking
- Container vulnerability scanning
- Dependency scanning
- Automated security checks

## Technologies Used

Cloud:
- AWS

Infrastructure:
- Terraform

Containers:
- Docker

CI/CD:
- GitHub Actions

Monitoring:
- CloudWatch

Security:
- Trivy
- WPScan

Version Control:
- GitHub
