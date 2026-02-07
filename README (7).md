# Nginx High Availability, Auto Scaling & Disaster Recovery on AWS

## 📌 Problem Statement

A client is running applications on **AWS Cloud**, but their application is unable to handle increasing traffic.
To solve this, the client wants to introduce **Nginx as a reverse proxy** to manage load effectively.

Additionally, the client requires:

* **High Availability (HA)**
* **Disaster Recovery (DR)**
* **Scalability using Auto Scaling**
* **Rollback and version management**
* **Web hosting using Nginx + S3**
* **Path-based routing using a single ALB**
* **Secure IAM and S3 access**
* **CDN integration using CloudFront**

All tasks must be performed **inside AWS infrastructure (via EC2)** without using static AWS access keys.

---

## 🛠️ Architecture Overview

* **Nginx** as reverse proxy and web server
* **AMI-based versioning (V1 & V2)**
* **Auto Scaling Group (ASG)** for HA
* **Application Load Balancer (ALB)**
* **S3** for static image hosting
* **IAM Roles & Policies** for secure access
* **CloudFront (CDN)** for low latency
* **Bastion Host** for secure SSH access

---

## 📆 Day-wise Task Breakdown

---

## 🔹 Day 1 – Nginx Setup, AMI Versioning & Auto Scaling

### Step 1: Nginx Installation & AMI Creation

* Launch an EC2 instance
* Install **Nginx**
* Configure Nginx basic setup
* Create **AMI-1 (Version V1)**

### Step 2: Version Upgrade Strategy

* Launch instance from **AMI-1**
* Modify configuration / upgrade Nginx
* Create **AMI-2 (Version V2)**
* Launch instance from **AMI-2**

✔️ Final Result:

* **Two AMIs** (V1 and V2)

---

### Step 3: Auto Scaling & Load Balancer

* Create **Launch Template** using AMIs
* Create **Auto Scaling Group (ASG)**
* Attach ASG to **Application Load Balancer**
* Configure scaling policies:

  * Average CPU Utilization
  * Network Bytes In / Out
  * ALB Request Count per Target

### Step 4: Load Testing

* Generate load on Nginx server
* Observe auto scaling behavior
* Analyze scale-out and scale-in events

---

### Step 5: Version Upgrade & Rollback

* Upgrade ASG from **V1 → V2**
* Observe application issues
* **Rollback ASG from V2 → V1**

✔️ Rolling Deployment strategy used
✔️ AMI-based rollback supported

---

## 🔹 Day 2 – Web Hosting Using Nginx + S3

### Requirements

* Nginx must host a webpage
* Images must be fetched directly from **S3**
* All actions must be done **from EC2**
* **No access keys / secret keys**

### Implementation

* Clone image repository from Git
* Upload images to S3 using **IAM Role + aws-cli**
* Configure Nginx frontend
* Images served directly from S3 bucket

---

## 🔹 Day 3 – ASG Health Check & Self Healing

### Objective

Test Auto Scaling Group behavior when an instance becomes unhealthy.

### Steps

* SSH into EC2
* Intentionally break Nginx / server health
* Observe:

  * Instance marked unhealthy
  * ASG terminates unhealthy instance
  * New instance launched automatically

✔️ Desired capacity maintained
✔️ Self-healing verified

---

## 🔹 Special Client Notes (Must Follow)

### NOTE 1

* Create utility/scripts to:

  * Create AMI of specific version
  * Attach AMI to ASG
  * Perform rolling deployment
  * Revert back to older version

### NOTE 2

* **All tasks must be performed manually first**
* Automation comes later

---

## ⭐ Good To Do (Bonus)

* Implement **Blue-Green Deployment**
* Place **CloudFront** in front of ALB
* Use images from **S3**
* Continue Day-1 architecture

### 📸 Screenshots:

🔹 Terminal
<img width="1854" height="1098" alt="Pasted image" src="https://github.com/user-attachments/assets/b92fcef0-6c1c-48fd-94d8-ce07e242ba75" />

🔹 AMIs
<img width="1854" height="1098" alt="Pasted image (9)" src="https://github.com/user-attachments/assets/f8835e9f-d969-4f98-b41f-c762657600c0" />

🔹 S3
<img width="1854" height="1098" alt="Pasted image (2)" src="https://github.com/user-attachments/assets/57ff8508-d785-4994-a5a1-aac077edc06a" />

🔹 Role
<img width="1854" height="1098" alt="Pasted image (3)" src="https://github.com/user-attachments/assets/dfd3b69d-6435-4c4c-8ca0-82d2a1c67b50" />

🔹 Version 1
<img width="1854" height="1098" alt="Pasted image (4)" src="https://github.com/user-attachments/assets/e09ab218-2a95-4033-89a9-82165d6d283c" />
<img width="1854" height="1098" alt="Pasted image (5)" src="https://github.com/user-attachments/assets/c02f50f2-64d2-4a8c-9c7a-24352a48bb0b" />

🔹 Breaking Sever
<img width="1854" height="1098" alt="Pasted image (6)" src="https://github.com/user-attachments/assets/f768c81a-7e57-4c7c-98f9-18140aa51dd7" />

🔹 Target Groups (Unhealthy Server)
<img width="1854" height="1098" alt="Pasted image (7)" src="https://github.com/user-attachments/assets/5db442e3-1740-4cbd-885a-171c39ecca8a" />

🔹 ASG (Self Healing)
<img width="1854" height="1098" alt="Pasted image (8)" src="https://github.com/user-attachments/assets/300027b7-6469-45b2-8c39-b8675f8201cc" />

---

## 🔹 Day 4 – Path-Based Routing with ALB

### Infrastructure Setup

* 1 EC2 in each **private subnet**
* 1 Bastion host in **public subnet**
* SSH (22):

  * Bastion → Public IP only
  * Nginx EC2 → Bastion only

### Nginx Configuration

* EC2-1 → `/ninja1` → displays **Image-1**
* EC2-2 → `/ninja2` → displays **Image-2**

### ALB Configuration

* Create **2 Target Groups**
* ALB Listener Rules:

  * `{ALB-DNS}/ninja1` → EC2-1
  * `{ALB-DNS}/ninja2` → EC2-2

### Security Rules

* ALB port 80 → Public IP only
* Nginx port 80 → ALB only

### 📸 Screenshots:

🔹 VPC
<img width="1846" height="1091" alt="Pasted image (11)" src="https://github.com/user-attachments/assets/beb52fc9-bf20-40b3-90da-1952e86c64d2" />

🔹 Instances
<img width="1846" height="1091" alt="Pasted image (7)" src="https://github.com/user-attachments/assets/fc969f31-3392-4f6f-8b8f-5e7289e180c3" />

🔹 Security Gruops
<img width="1846" height="1091" alt="Pasted image (8)" src="https://github.com/user-attachments/assets/965109d8-f954-4c69-98b8-584885f35efd" />
<img width="1846" height="1091" alt="Pasted image (9)" src="https://github.com/user-attachments/assets/41e17473-e2b7-4d5c-9c02-febf71fde6d6" />
<img width="1846" height="1091" alt="Pasted image (10)" src="https://github.com/user-attachments/assets/32a8b476-83a8-4d2d-a344-5eac53a30892" />

🔹 S3
<img width="1846" height="1091" alt="Pasted image (12)" src="https://github.com/user-attachments/assets/2a32550e-7fcc-4045-a092-4d7830e92bce" />

🔹 Target Group
<img width="1846" height="1091" alt="Pasted image (6)" src="https://github.com/user-attachments/assets/0d691da0-3334-434b-98cc-4899278ea9ff" />

🔹 ALB
<img width="1846" height="1091" alt="Pasted image (5)" src="https://github.com/user-attachments/assets/cbe328f1-af1e-404b-b2b3-ea75d01f8c3e" />

#### 🔹 Version 1

<img width="1854" height="1168" alt="Pasted image (2)" src="https://github.com/user-attachments/assets/d2a37136-3ae7-430c-96b2-04c118ececfd" />
<img width="1854" height="1168" alt="Pasted image (3)" src="https://github.com/user-attachments/assets/30ce401c-ad45-49e0-b77a-28f77a75d25c" />

#### 🔹 Version 2

<img width="1854" height="1168" alt="Pasted image" src="https://github.com/user-attachments/assets/8974a6a9-e581-4461-a601-024f9dc837de" />
<img width="1854" height="1168" alt="Pasted image (4)" src="https://github.com/user-attachments/assets/7f3edaae-915a-4907-972c-baf48f8c241c" />

---

## 🔹 Day 5 – S3 & IAM Access Control (US-East-1)

### S3 Setup

* Create S3 bucket in **us-east-1**
* Create folders:

  * `prod/`
  * `nonprod/`
* Upload different images in each folder

### IAM Configuration

* Create IAM User
* Create IAM Role (S3 Full Access)
* Apply policies:

  * IAM User:

    * ❌ No access to `prod`
    * ✅ Access to `nonprod`
  * Bucket Access:

    * Root user
    * IAM user
    * Nginx EC2 only

✔️ Least privilege enforced
✔️ Folder-level restriction implemented

### 📸 Screenshots:

🔹 Creating User and Policy
<img width="1846" height="1091" alt="Pasted image (4)" src="https://github.com/user-attachments/assets/4c332b57-5b40-4ef3-a709-82f737f109bd" />
<img width="1846" height="1091" alt="Pasted image (5)" src="https://github.com/user-attachments/assets/6cd182f5-4495-4c3e-b45d-37099f9e99bc" />

🔹 User's S3 Bucket
<img width="1846" height="1091" alt="Pasted image" src="https://github.com/user-attachments/assets/03d73af3-4036-4c99-89fd-a47017b375f5" />
<img width="1846" height="1091" alt="Pasted image (2)" src="https://github.com/user-attachments/assets/5c74bffa-274b-4654-ab74-accfc1c91738" />
<img width="1846" height="1091" alt="Pasted image (3)" src="https://github.com/user-attachments/assets/bc032406-978a-42d7-8543-14696342ad61" />

---

## 🔹 Day 6 – IAM Trust Relationship & CDN

### Issue

Policy worked for S3 but failed when attached to CDN.

### Solution

* Configure **IAM Trust Relationship**
* Allow CloudFront to assume role

### Implementation

* Deploy **CloudFront**
* Fetch images via CDN instead of S3
* Use **same IAM role** as EC2 (no policy change)

### Additional Task

* Create personal IAM user
* Assign **minimum required permissions**

### 📸 Screenshots:

🔹 Role
<img width="1846" height="1091" alt="Pasted image (4)" src="https://github.com/user-attachments/assets/c94486da-098b-4fe0-8717-8aa22372d1af" />

🔹 CloudFront
<img width="1846" height="1091" alt="Pasted image (3)" src="https://github.com/user-attachments/assets/2e9470b0-2e01-47d9-940c-3efa54f0a8b3" />

🔹 Images via CDN 
<img width="1846" height="1091" alt="Pasted image" src="https://github.com/user-attachments/assets/2c04d090-b19a-4cef-889f-da6a68526ab5" />
<img width="1846" height="1091" alt="Pasted image (2)" src="https://github.com/user-attachments/assets/62a4bb57-f378-4f59-896e-55086bb900aa" />

---

## ✅ Final Outcomes

✔️ High Availability Nginx setup
✔️ Auto Scaling & Self Healing
✔️ Versioned AMI strategy
✔️ Rolling deployment & rollback
✔️ Secure IAM & S3 integration
✔️ Path-based routing using ALB
✔️ CDN integration for low latency

---

## 📌 Tools & Services Used

* EC2
* Nginx
* AMI
* Auto Scaling Group
* Application Load Balancer
* S3
* IAM (Users, Roles, Policies)
* CloudFront
* AWS CLI
* Git

---

## 📎 Conclusion

This assignment demonstrates **real-world DevOps problem solving** using AWS services with a strong focus on:

* Scalability
* Security
* High availability
* Disaster recovery
* Zero-downtime deployment
