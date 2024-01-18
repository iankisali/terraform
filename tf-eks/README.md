## Terraform and EKS 

The terraform files in this directory creates Amazon EKS with the following:
- `Virtual Private Cloud(vpcs) for Master and worker node`
- `3 private subnets -> NAT Gateway attached`
- `3 public subnets -> igw attached`
- `EKS Cluster with 3 worker nodes deployed in 3 AZ's`
- `Each AZ has 1 public and private subnets -> total of 3AZs and 6 subnets`

### Steps to create an eks cluster
1. Creating EKS IAM role
2. Creating VPC for worker nodes
3. Create an EKS cluster (Master Nodes)
4. Connect kubectl with EKS cluster
5. Creating ec2 IAM role for nodegroup
6. Create nodegroup and attach to EKS cluster
7. Configure autoscaling
8. Deploy app to EKS cluster

To check on the changes to be made in cloud before applying:
- `terrafrom plan`

To run the terraform files:

- `terraform apply --auto-approve`

An alternative to terraform is using AWS Cloudformation template but it's specific to only AWS.

Prerequisites to connect to a cluster include AWS CLI, Kubectl and aws-iam-authenticator

### Types of worker nodes
- Self managed -> EC2
- Semi-managed -> Nodegroup
- Fully managed -> Fargate