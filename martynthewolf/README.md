# martynthewolf Infrastructure

This directory contains the Terraform configuration for the `martynthewolf` environment.

## What is created?

### 1. The Network (VPC)
- **VPC (`aws_vpc.main`)**: A private network space with the address range `10.0.0.0/16`.
- **Subnet (`aws_subnet.martynthewolf_subnet`)**: A sub-section of the VPC (`10.0.1.0/24`) where the virtual server will live.
- **Internet Gateway (`aws_internet_gateway.internet_gateway`)**: Allows traffic to flow between the VPC and the internet.
- **Route (`aws_route.product_internet`)**: A rule that tells the network to send all outside traffic to the Internet Gateway.

### 2. Security (Firewall)
- **Security Group (`aws_security_group.martynthewolf_sg`)**: Acts as a firewall for the virtual server.
  - **Inbound Rules**:
    - Allows SSH (port 22) from a specific IP address (`144.124.161.166/32`).
    - Allows Ping (ICMP) from the other environment (`10.1.0.0/16`) and the specific IP above.
  - **Outbound Rules**:
    - Allows all traffic to go out to the internet.

### 3. Compute (The Server)
- **Key Pair (`aws_key_pair.product_key`)**: Uploads an SSH public key (`~/.ssh/product_test_key.pub`) so you can log into the server.
- **EC2 Instance (`aws_instance.product_test`)**: A virtual machine of type `t3.micro`. It is assigned a public IP address and uses the key pair and security group defined above.
- **IAM Role (`aws_iam_role.ssm_role`)**: A role that allows the server to use AWS Systems Manager (SSM) for management.

## Deployment

To deploy this environment:

```bash
terraform init
terraform apply
```

This will prompt for confirmation. Type `yes` to proceed.
