# VPC Peering (The Connection)

This directory contains the Terraform configuration for connecting the `martynthewolf` and `veritytheotter` environments.

## What is created?

### 1. Data Sources
This project is designed to be run after the other two. It doesn't create its own VPCs; instead, it uses **Data Sources** to "look up" the VPCs that were already created by the other two projects. This way, it can get their ID numbers and address ranges dynamically.

### 2. Peering Connection
- **VPC Peering Connection (`aws_vpc_peering_connection.peer`)**: This is a bridge created in the `martynthewolf` environment. It asks to connect to the VPC in the `veritytheotter` environment.
- **Peering Accepter (`aws_vpc_peering_connection_accepter.peer_accept`)**: This is the other side of the bridge. It automatically accepts the connection from `martynthewolf`.

### 3. Routes (The Map)
The bridge is not enough on its own; both networks need to know how to use it.
- **Route 1 (`aws_route.martynthewolf_to_veritytheotter`)**: Tells the `martynthewolf` network: "If you want to reach anything in `10.1.0.0/16` (the otter network), use the peering bridge."
- **Route 2 (`aws_route.veritytheotter_to_martynthewolf`)**: Tells the `veritytheotter` network: "If you want to reach anything in `10.0.0.0/16` (the wolf network), use the peering bridge."

## Prerequisites

Before running this, you must have successfully deployed the code in the other two directories:
- `../martynthewolf`
- `../veritytheotter`

## Deployment

To deploy this connection:

```bash
terraform init
terraform apply
```

This will prompt for confirmation. Type `yes` to proceed.
