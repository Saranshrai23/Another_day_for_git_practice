# Deployment Strategies with Amazon S3 Integration

## 📌 Objective

The objective of this assignment is to **understand, compare, and implement multiple application deployment strategies** while integrating **Amazon S3** for managing static assets and deployment artifacts.

This assignment focuses on **real-world deployment patterns** used in DevOps and Cloud environments and demonstrates how AWS services like **EC2, Auto Scaling Groups, Load Balancers, and S3** work together during deployments.

---

## 🧠 Deployment Strategies Covered

1. Recreate Deployment
2. Rolling Deployment
3. Blue-Green Deployment
4. A/B Deployment (theoretical understanding)
5. Canary Deployment

---

## 📖 Part 1: Research & Understanding

### 1️⃣ Recreate Deployment

**Description:**
The existing application version is completely stopped and replaced with a new version.

**Advantages:**

* Simple to implement
* No additional infrastructure required
* Easy to understand for beginners

**Disadvantages:**

* Application downtime during deployment
* Not suitable for production systems requiring high availability

---

### 2️⃣ Rolling Deployment

**Description:**
The application is updated gradually by replacing instances one by one while keeping the service running.

**Advantages:**

* No downtime
* Controlled and gradual rollout
* Easy rollback if issues occur

**Disadvantages:**

* Multiple versions may run simultaneously
* Requires load balancer and ASG configuration

---

### 3️⃣ Blue-Green Deployment

**Description:**
Two identical environments (Blue and Green) are maintained. Traffic is switched from the old version (Blue) to the new version (Green).

**Advantages:**

* Zero downtime
* Instant rollback
* Clean separation of environments

**Disadvantages:**

* Higher infrastructure cost
* Requires careful environment synchronization

---

### 4️⃣ A/B Deployment

**Description:**
Different versions of the application are served to different user groups to compare behavior and performance.

**Advantages:**

* Helps in feature testing and user behavior analysis
* Useful for UI/UX experiments

**Disadvantages:**

* Complex traffic routing
* Requires analytics and monitoring tools

---

### 5️⃣ Canary Deployment

**Description:**
A new version is released to a small subset of users or instances before full rollout.

**Advantages:**

* Reduced risk
* Early detection of bugs or performance issues
* Safer production deployments

**Disadvantages:**

* Monitoring complexity
* Requires advanced metrics and logging

---

## 🛠️ Part 2: Implementation Details

### ✅ Must Do Implementations

---

## 🚀 Recreate Deployment Implementation

### Architecture Overview:

* EC2 Instance
* Amazon Machine Image (AMI)
* Amazon S3 (Static Assets)

### Steps:

1. Launch an EC2 instance and deploy the application manually.
2. Create an **AMI snapshot** of the EC2 instance after successful deployment.
3. Create an **Amazon S3 bucket** to store:

   * Images
4. Configure the application to load static assets directly from S3.
5. For application updates:

   * Stop the existing EC2 instance
   * Launch a new instance using the updated AMI

📌 **Outcome:**
Application redeployed by replacing the entire instance.

### 📸 Screenshots:

🔹 Instances
<img width="1547" height="807" alt="image" src="https://github.com/user-attachments/assets/f8715e6d-0cd2-444a-af05-8ffac3345e26" />


🔹 AMI
![Version-1 (AMI)](https://github.com/user-attachments/assets/24a3c4b5-9e42-44fa-80ac-2c9b7ba358e1)


🔹 Bucket

![Bucket policy](https://github.com/user-attachments/assets/2869b296-263d-48a6-ba82-e3fc5194a4cb)
![Bucket-1](https://github.com/user-attachments/assets/abe6ccff-45fd-4135-90af-71d16ada8ba0)



#### 🔹 Version 1

![Version-1](https://github.com/user-attachments/assets/923df424-18ff-4d70-ae4f-3936c42bd3de)


#### 🔹 Version 2

![Version-2](https://github.com/user-attachments/assets/46495e62-d2af-435b-8edd-ea8cde085c53)


---

## 🔄 Rolling Deployment Implementation

### Architecture Overview:

* Auto Scaling Group (ASG)
* Launch Template / Launch Configuration
* Load Balancer
* Amazon S3

### Steps:

1. Create an Auto Scaling Group with:

   * Minimum instances
   * Maximum instances
2. Deploy **Version 1** of the application.
3. Store deployment artifacts like images in an S3 bucket.
4. Create a new launch configuration/template with **Version 2**.
5. Update the ASG to use the new launch configuration.
6. Instances are gradually replaced without downtime.

📌 **Outcome:**
Application updates happen smoothly with zero downtime.

### 📸 Screenshots:
🔹 Instances
<img width="1846" height="1091" alt="Pasted image (8)" src="https://github.com/user-attachments/assets/9c5505a9-f3ad-4fec-b5f0-89fbae65c5cd" />

🔹 S3 Bucket
<img width="1854" height="1168" alt="Pasted image (7)" src="https://github.com/user-attachments/assets/2a1dca74-078e-46cc-ae2f-db6756411a60" />

🔹 Launch Templates
<img width="1854" height="1168" alt="Pasted image (4)" src="https://github.com/user-attachments/assets/4cbbcf23-4fe1-4e2a-8edb-bf2f8d3392c7" />
<img width="1846" height="1091" alt="Pasted image (10)" src="https://github.com/user-attachments/assets/308cad85-41e6-4772-b941-8e4e60db7cff" />
<img width="1846" height="1091" alt="Pasted image (9)" src="https://github.com/user-attachments/assets/bfba734e-593a-437d-bfa1-4be1a3c7c000" />

🔹 Target Group
<img width="1854" height="1168" alt="Pasted image (3)" src="https://github.com/user-attachments/assets/a70bea1b-215b-4779-bf23-2709663314ae" />

🔹 ALB
<img width="1854" height="1168" alt="Pasted image" src="https://github.com/user-attachments/assets/ee295cf4-ea69-4c9c-a876-431a4a1f7b9d" />
<img width="1854" height="1168" alt="Pasted image (2)" src="https://github.com/user-attachments/assets/c97674b4-cbd4-4dff-ab43-50672cb0f599" />

🔹 ASG
<img width="1846" height="1091" alt="Pasted image (11)" src="https://github.com/user-attachments/assets/38692820-d1d7-4d5d-af87-b22f44cbe5d6" />

#### 🔹 Version 1

<img width="1854" height="1168" alt="Pasted image (5)" src="https://github.com/user-attachments/assets/2670faed-1ee1-4061-be97-02a69df47fa4" />
<img width="1854" height="1168" alt="Pasted image (6)" src="https://github.com/user-attachments/assets/e88e39f5-e86d-45be-9b98-9d9f4fa94d9d" />


#### 🔹 Version 2

<img width="1846" height="1091" alt="Pasted image (13)" src="https://github.com/user-attachments/assets/c6063ca0-b3eb-486f-b4f4-e9e84c359bb2" />
<img width="1846" height="1091" alt="Pasted image (12)" src="https://github.com/user-attachments/assets/db454af9-5ad4-4dfa-bd7f-9086cb115c56" />
<img width="1846" height="1091" alt="Pasted image (14)" src="https://github.com/user-attachments/assets/47eb785d-255e-4bfb-b0be-87a8a54b8d0f" />


---

## 🌟 Good To Do Implementations

---

## 🔵🟢 Blue-Green Deployment Implementation

### Architecture Overview:

* Blue Environment (EC2)
* Green Environment (EC2)
* Application Load Balancer
* Amazon S3 Image

### Steps:

1. Create two identical EC2 environments (Blue & Green).
2. Deploy the current version to the Blue environment.
3. Deploy the new version to the Green environment.
4. Store environment-specific configuration files in S3.
5. Switch traffic using the Load Balancer from Blue to Green.
6. Roll back instantly if issues occur.

📌 **Outcome:**
Zero-downtime deployment with instant rollback capability.

### 📸 Screenshots:
🔹 Instances
<img width="1860" height="1095" alt="Pasted image (10)" src="https://github.com/user-attachments/assets/a2c9dd09-2b7b-448e-b599-5a8c987b5670" />
<img width="1860" height="1095" alt="Pasted image (11)" src="https://github.com/user-attachments/assets/8c7d0b7a-d9c4-4eab-811b-b6bec6fdcbaf" />

🔹 AMIs
<img width="1860" height="1095" alt="Pasted image (12)" src="https://github.com/user-attachments/assets/454eee2c-7472-4503-8766-a981a6bbc6de" />

🔹 S3
<img width="1860" height="1095" alt="Pasted image (13)" src="https://github.com/user-attachments/assets/67064b40-9573-465f-8e29-b252d2e80a21" />

🔹 Target Group
<img width="1860" height="1095" alt="Pasted image (7)" src="https://github.com/user-attachments/assets/cc6fd5bf-d86f-4f48-a12b-5c8d0efae39f" />

🔹 ALB
<img width="1860" height="1095" alt="Pasted image (8)" src="https://github.com/user-attachments/assets/b9e316ad-9254-4a76-bab7-38d7a557c7d2" />

🔹 ASG
<img width="1860" height="1095" alt="Pasted image (9)" src="https://github.com/user-attachments/assets/1fb7c42f-6402-41e8-970d-c71b6a3968a8" />

#### 🔹 Version 1

<img width="1854" height="1168" alt="Pasted image" src="https://github.com/user-attachments/assets/fafc195f-0454-4590-a975-e2a75e7b732e" />
<img width="1854" height="1168" alt="Pasted image (2)" src="https://github.com/user-attachments/assets/87a3e11a-4d47-4da3-b5ef-5a37b65c498c" />
<img width="1854" height="1168" alt="Pasted image (3)" src="https://github.com/user-attachments/assets/d94d3a16-16fe-44ba-990e-dc473a68158a" />

#### 🔹 Version 2

<img width="1854" height="1168" alt="Pasted image (4)" src="https://github.com/user-attachments/assets/7abe3307-7fc6-49a9-8e26-290d749b1de2" />
<img width="1854" height="1168" alt="Pasted image (5)" src="https://github.com/user-attachments/assets/2eb79aec-44e1-42c0-8994-40d49ba48441" />
<img width="1854" height="1168" alt="Pasted image (6)" src="https://github.com/user-attachments/assets/4c9b4162-b99d-4e8d-9957-fcdf48025378" />

---

## 🐤 Canary Deployment Implementation

### Architecture Overview:

* Auto Scaling Group
* Load Balancer
* Amazon S3 (Images)

### Steps:

1. Deploy the new version to a small subset of instances.
2. Route limited traffic to these instances.
3. Monitor:

   * Application performance
   * Error rates
   * User feedback
4. Store logs and metrics in an S3 bucket.
5. Gradually increase traffic if results are stable.

📌 **Outcome:**
Low-risk deployment with real-time validation.

### 📸 Screenshots:
🔹 Instances

#### 🔹 Version 1

#### 🔹 Version 2

---

## 🧪 Tools & Services Used

* Amazon EC2
* Amazon S3
* Auto Scaling Group (ASG)
* Application Load Balancer
* Amazon Machine Image (AMI)
* Linux (Ubuntu)

---

## 🎯 Learning Outcomes

* Clear understanding of multiple deployment strategies
* Hands-on experience with AWS infrastructure
* Practical integration of Amazon S3 in deployments
* Improved knowledge of real-world DevOps workflows

---

## ✅ Conclusion

This assignment demonstrates how different deployment strategies can be implemented using AWS services. By integrating **Amazon S3** for asset management and artifacts, the deployment process becomes more scalable, reliable, and production-ready.

