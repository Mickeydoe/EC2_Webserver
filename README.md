
### 📄 `README.md`

```markdown
# 🚀 Terraform AWS EC2 Setup with Custom VPC

This project uses Terraform to provision an EC2 instance inside a custom VPC on AWS. The instance is publicly accessible and configured to run a web server (e.g., Apache) using a user data script. It includes the creation of essential networking components like a VPC, subnet, internet gateway, route table, and security group.

---

## 🛠️ Features

- ✅ Custom VPC and Subnet
- ✅ Internet Gateway and Route Table for internet access
- ✅ Security Group allowing HTTP (port 80) and SSH (port 22)
- ✅ EC2 instance with user data to bootstrap Apache
- ✅ Public IP assignment for direct access

---

## 📁 Project Structure

```
.
├── main.tf              # Main Terraform configuration
├── userdata.sh          # Startup script to configure Apache on EC2
└── README.md            # Project documentation
```

---

## 🚧 Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- AWS account with programmatic access (access key & secret)
- IAM permissions to manage EC2, VPC, and networking
- AWS CLI (optional, for credential setup)

---

## 🔐 AWS Credentials Setup

Set your AWS credentials as environment variables:

```bash
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
```

Alternatively, configure using the AWS CLI:

```bash
aws configure
```

---

## 🚀 How to Use

1. **Clone the Repository**

```bash
git clone https://github.com/your-username/terraform-aws-ec2-vpc.git
cd terraform-aws-ec2-vpc
```

2. **Initialize Terraform**

```bash
terraform init
```

3. **Preview the Plan**

```bash
terraform plan
```

4. **Apply the Infrastructure**

```bash
terraform apply
```

5. **Access the EC2 Instance**

Once provisioning completes, Terraform will output the public IP (if configured). You can:

- SSH into the instance
- Open the browser and visit `http://<public-ip>` to view the Apache web server

---

## 📜 User Data Script

The `userdata.sh` file is used to automatically install and start Apache during instance launch. You can modify it to suit your server setup needs.

Example content:
```bash
#!/bin/bash
apt update -y
apt install apache2 -y
systemctl start apache2
systemctl enable apache2
echo "Hello from $(hostname)" > /var/www/html/index.html
```

---

## 🔁 Teardown

To destroy all infrastructure created by this project:

```bash
terraform destroy
```

---

## 🧠 Notes

- Ensure your chosen AMI ID (`ami-00a929b66ed6e0de6`) is valid in the `us-east-1` region.
- Public IPs are assigned via `map_public_ip_on_launch = true` in the subnet.
- This project avoids using default VPCs and builds everything from scratch for clarity and control.

---

## 📝 License

This project is open-source and available under the [MIT License](LICENSE).

---

