# Assignment-01: Load Balancer & Auto Scaling Group (Spring 3 Hibernate)

## Objective

The objective of this assignment is to design and implement a **highly available, scalable, and secure AWS infrastructure** for deploying a **Spring 3 Hibernate application**. The application is deployed on **private EC2 instances** and accessed via a **public Application Load Balancer (ALB)**.

The infrastructure ensures:

* High Availability using multiple Availability Zones
* Scalability using Auto Scaling Group (ASG)
* Security using private subnets, security groups, and a bastion host

Application Source:

* Spring 3 Hibernate Application: [https://github.com/opstree/spring3hibernate.git](https://github.com/opstree/spring3hibernate.git)

---

## Architecture Overview

The infrastructure is designed inside a single AWS region (**ap-south-1**) and consists of the following major components:

* **VPC** with public and private subnets
* **Application Load Balancer (ALB)** in public subnets
* **Auto Scaling Group (ASG)** for application servers in private subnets
* **NAT Gateway** for outbound internet access from private subnets
* **Bastion Host** for secure SSH access
* **Security Groups** for controlled network access

---

## Infra Diagram

![alt text](Screenshots/infra.png)
---

## Networking Design

### VPC

* CIDR Block: `10.0.0.0/17`
* Region: `ap-south-1`

### Subnets

**Public Subnets** (Multi-AZ):

* Used for ALB and Bastion Host
* Example CIDRs:

  * 10.0.16.0/25
  * 10.0.17.0/25

**Private Subnets** (Multi-AZ):

* Used for Spring application EC2 instances
* Example CIDRs:

  * 10.0.0.0/21
  * 10.0.8.0/21

---

## Internet & Routing

* **Internet Gateway (IGW)** attached to VPC
* **Public Route Table**:

  * Route: `0.0.0.0/0 → IGW`
* **Private Route Table**:

  * Route: `0.0.0.0/0 → NAT Gateway`

---

## Load Balancer (ALB)

* Type: Application Load Balancer
* Deployed in public subnets
* Listener:

  * HTTP : 8080
* Forwards traffic to Target Group on port `8080`

> 📸 **ALB Details**
![alt text](<Screenshots/image copy.png>)

---

## Target Group

* Target Type: Instance
* Protocol: HTTP
* Port: 8080
* Health Check Path: `/`

---

## Auto Scaling Group (ASG)

* Launch Template based on pre-baked AMI
* Deployed in **private subnets only**
* Desired Capacity: 2
* Min Size: 2
* Max Size: 3
* Health Check Type: ELB

> 📸 **ASG Configuration**
![alt text](Screenshots/asg.png)

---

## Launch Template

* AMI: `springapp-ami`
* Instance Type: `t2.micro`
* Security Group: `app-SG`
* Public IP: Disabled
* Key Pair: Optional

> 📸 **Launch Template**
![alt text](<Screenshots/image copy 2.png>)

---

## Security Groups

### ALB Security Group (alb-SG)

**Inbound Rules**:

* HTTP 8080 → `0.0.0.0/0`

**Outbound Rules**:

* All traffic → `0.0.0.0/0`

### Application Security Group (app-SG)

**Inbound Rules**:

* HTTP 8080 → alb-SG
* SSH 22 → bastion-SG

**Outbound Rules**:

* All traffic → `0.0.0.0/0`

---

## Bastion Host

* Deployed in public subnet
* Used to securely SSH into private EC2 instances
* Only bastion host is allowed SSH access to app servers

> 📸 **Bastion Host**
![alt text](<Screenshots/image copy 3.png>)

---

## NAT Gateway

* Deployed in public subnet
* Allows private EC2 instances to:

  * Download packages
  * Access GitHub & Maven repositories

---

## Application Access

* Application is accessed via ALB DNS name:

```groovy
http://<ALB-DNS>:8080/
```
![alt text](<Screenshots/image copy 4.png>)
![alt text](<Screenshots/image copy 5.png>)
![alt text](<Screenshots/image copy 7.png>)
---

## Final Outcome

✔ Spring 3 Hibernate application running on private EC2 instances
✔ Load balanced traffic via ALB
✔ Auto Scaling based on demand
✔ Secure architecture using private subnets and security groups
✔ Highly available across multiple AZs

---

**Author:** Mukesh Kharb
