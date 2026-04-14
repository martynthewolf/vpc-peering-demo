# Infrastructure Documentation

This project contains Terraform (or OpenTofu) code to set up two separate AWS environments and connect them via VPC Peering.

## Project Structure

The project is divided into three main parts:

- **[martynthewolf](./martynthewolf/):** Sets up the first environment.
- **[veritytheotter](./veritytheotter/):** Sets up the second environment.
- **[peering](./peering/):** Connects the two environments together.

---

### 1. martynthewolf Environment
This directory creates a basic AWS network:
- A **VPC** (Virtual Private Cloud) with the address range `10.0.0.0/16`.
- A **Subnet** for placing resources.
- A **Security Group** (firewall) that allows SSH access and ICMP (ping).
- An **Internet Gateway** to allow the network to talk to the internet.
- An **EC2 Instance** (virtual server) running in this network.

### 2. veritytheotter Environment
This directory creates a similar setup to the first one but with different settings:
- A **VPC** with the address range `10.1.0.0/16`.
- A **Subnet** and **Security Group**.
- An **EC2 Instance** running in this network.
- Note: This environment does not have its own Internet Gateway; it is designed to be reached via the peering connection.

### 3. Peering (The Connection)
This directory contains the code that links the two networks together:
- It finds the VPCs created by the other two projects.
- It establishes a **VPC Peering Connection**, which is like a private bridge between two networks.
- It updates the **Route Tables** in both networks so they know how to find each other.

---

## How to use this project

To set up the entire infrastructure, you should follow these steps in order:

1. **Set up martynthewolf:**
   ```bash
   cd martynthewolf
   terraform init
   terraform apply
   ```

2. **Set up veritytheotter:**
   ```bash
   cd ../veritytheotter
   terraform init
   terraform apply
   ```

3. **Set up Peering:**
   ```bash
   cd ../peering
   terraform init
   terraform apply
   ```

## Prerequisites

- **AWS CLI Profiles:** You must have two AWS profiles configured: `martynthewolf` and `veritytheotter`.
- **SSH Key:** The code expects an SSH public key at `~/.ssh/product_test_key.pub`.
- **Terraform / OpenTofu:** Installed on your local machine.
