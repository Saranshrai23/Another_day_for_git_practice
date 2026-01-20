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

<img width="720" height="605" alt="image" src="https://github.com/user-attachments/assets/ebe70dd1-2029-4e1b-b67d-e6481b68fa47" />

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
<img width="1918" height="957" alt="image" src="https://github.com/user-attachments/assets/7ff58168-8901-4f8f-a1e3-cac528b15150" />


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

<img width="1918" height="963" alt="image" src="https://github.com/user-attachments/assets/6809dd17-939e-4dd1-a380-56276452eea4" />


---

## Launch Template

* AMI: `springapp-ami`
* Instance Type: `t2.micro`
* Security Group: `app-SG`
* Public IP: Disabled
* Key Pair: Optional

> 📸 **Launch Template**

<img width="1918" height="967" alt="image" src="https://github.com/user-attachments/assets/40120b29-b651-4be3-89ae-f35d8cc6b639" />


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
<img width="1918" height="915" alt="image" src="https://github.com/user-attachments/assets/ebe0039b-f4ba-481a-9551-7d1640c8eede" />

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

<img width="1918" height="845" alt="image" src="https://github.com/user-attachments/assets/6e6800f8-fce4-46cd-baa2-23bd9267e8be" />

<img width="1918" height="998" alt="image" src="https://github.com/user-attachments/assets/6adad1af-f2fd-4f4c-a098-002f61d3be09" />

<img width="1916" height="847" alt="image" src="https://github.com/user-attachments/assets/ad4a0531-d52c-4c4d-a1d0-d8e67e258d24" />

<img width="1912" height="942" alt="image" src="https://github.com/user-attachments/assets/116a8b64-b8a0-4860-8a4e-a2299bc06989" />


---

## Final Outcome

✔ Spring 3 Hibernate application running on private EC2 instances
✔ Load balanced traffic via ALB
✔ Auto Scaling based on demand
✔ Secure architecture using private subnets and security groups
✔ Highly available across multiple AZs

---

**Author:** Saransh Rai
