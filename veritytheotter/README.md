# veritytheotter Infrastructure

This directory contains the Terraform configuration for the `veritytheotter` environment.

## What is created?

### 1. The Network (VPC)
- **VPC (`aws_vpc.main`)**: A private network space with the address range `10.1.0.0/16`.
- **Subnet (`aws_subnet.veritytheotter_subnet`)**: A sub-section of the VPC (`10.1.1.0/24`) for the virtual server.
- **Note**: This network does not have an Internet Gateway of its own. It is designed to communicate with the internet or other networks through the VPC Peering connection (once set up in the `peering` directory).

### 2. Security (Firewall)
- **Security Group (`aws_security_group.veritytheotter_sg`)**: Acts as a firewall for the virtual server.
  - **Inbound Rules**:
    - Allows SSH (port 22) from the `martynthewolf` environment (`10.0.0.0/16`).
    - Allows Ping (ICMP) from the `martynthewolf` environment (`10.0.0.0/16`).
  - **Outbound Rules**:
    - Allows all traffic to go out.

### 3. Compute (The Server)
- **Key Pair (`aws_key_pair.veritytheotter_key`)**: Uploads an SSH public key (`~/.ssh/product_test_key.pub`) for server login.
- **EC2 Instance (`aws_instance.veritytheotter_test`)**: A virtual machine of type `t3.micro`. It uses the key pair and security group defined above.

## Deployment

To deploy this environment:

```bash
terraform init
terraform apply
```

This will prompt for confirmation. Type `yes` to proceed.
