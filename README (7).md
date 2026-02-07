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
<img width="1547" height="807" alt="image" src="https://github.com/user-attachments/assets/087a08a4-d5f4-4af7-b48e-ae503d53a80d" />


🔹 S3 Bucket
![Uploading_Indexfiles_S3_CLI](https://github.com/user-attachments/assets/cae9c262-efc6-401d-bcb2-ba5f3d0f198e)


🔹 Launch Templates
![Launch_template_for_both_version](https://github.com/user-attachments/assets/4ed60d62-cca4-414f-8f5a-8baf4e50643e)

![chaged_rolling_template_to_2](https://github.com/user-attachments/assets/fc2ad5da-bb4c-4e12-95d4-e61faa5c80d8)



🔹 Target Group

![History_template](https://github.com/user-attachments/assets/421de956-81e4-4434-9ef3-2a5e51c7ee86)

![Health_status](https://github.com/user-attachments/assets/d9e2b6cf-b223-4d91-890c-30a2a74b7495)


🔹 ALB

![LB-version](https://github.com/user-attachments/assets/ee60b3e2-086f-4d65-bf6b-0a166b0966a1)


🔹 ASG

![refreshed_instance_rolling_update](https://github.com/user-attachments/assets/3cfdfd09-bf39-4e0b-ab29-f93713b2617d)

![removing_oldversion_adding_new_version](https://github.com/user-attachments/assets/076a1d81-f2a9-43cd-bae8-d224a3b67233)

![chaged_rolling_template_to_2](https://github.com/user-attachments/assets/a7a2cd2c-d0ed-4818-8a51-6eeac8c5d235)


#### 🔹 Version 1

![Version1_running](https://github.com/user-attachments/assets/55dbd67a-d357-449d-85ff-0724416b8c17)



#### 🔹 Version 2

![Version2_running](https://github.com/user-attachments/assets/b0529653-7b77-4748-b9c0-b9a8f4f76aea)



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
![Blue-Green](https://github.com/user-attachments/assets/2568b82c-f819-4464-bf6c-99a4c7b26023)


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

![Canary-3](https://github.com/user-attachments/assets/fa04df7e-f641-4868-923b-ca02ef7560c6)


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

