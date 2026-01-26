# EKS Terraform Infrastructure

This directory contains Terraform configurations for deploying an Amazon EKS (Elastic Kubernetes Service) cluster.

## 📁 Directory Structure

```
eks/
├── provider.tf      # AWS provider configuration
├── vpc.tf          # VPC, subnets, and networking resources
├── iam.tf          # IAM roles and policies for EKS
├── eks.tf          # EKS cluster configuration
├── nodegroup.tf    # EKS node group configuration
├── outputs.tf      # Terraform outputs
└── README.md       # This file
```

## 🏗️ Infrastructure Components

### 1. **VPC and Networking**
- VPC with CIDR block `10.0.0.0/16`
- 2 public subnets across different availability zones
- Internet Gateway for external connectivity
- Route tables and associations

### 2. **IAM Roles and Policies**
- **EKS Cluster Role**: Allows EKS to manage resources
- **Node Group Role**: Allows worker nodes to join the cluster
- Managed policies:
  - `AmazonEKSClusterPolicy`
  - `AmazonEKSWorkerNodePolicy`
  - `AmazonEKS_CNI_Policy`
  - `AmazonEC2ContainerRegistryReadOnly`

### 3. **EKS Cluster**
- Cluster name: `demo-eks`
- Kubernetes version: Latest stable
- Region: `ap-south-1` (Asia Pacific - Mumbai)

### 4. **Node Group**
- Node group name: `demo-ng`
- Instance type: `t3.medium`
- Scaling configuration:
  - Desired: 1 node
  - Minimum: 1 node
  - Maximum: 2 nodes

## 🚀 GitHub Actions Workflow

The infrastructure is deployed using the GitHub Actions workflow: `.github/workflows/eks-terraform-deploy.yml`

### Workflow Features

1. **Automated Plan on Pull Requests**
   - Runs `terraform plan` automatically
   - Posts plan output as a comment on the PR
   - Validates Terraform code formatting

2. **Automated Apply on Main Branch**
   - Deploys infrastructure when changes are merged to `main`
   - Only runs if changes affect the `eks/` directory

3. **Manual Triggers**
   - Can be manually triggered via GitHub UI
   - Supports three actions:
     - `plan` - Preview changes
     - `apply` - Apply changes
     - `destroy` - Destroy infrastructure

### Prerequisites

Before running the workflow, ensure the following secrets are configured in your GitHub repository:

1. **`AWS_ROLE_ARN`**: ARN of the IAM role for GitHub Actions OIDC authentication
   - Example: `arn:aws:iam::123456789012:role/github-actions-oidc-role`

2. **AWS OIDC Provider**: Configure AWS to trust GitHub Actions
   - Follow: [AWS OIDC Configuration Guide](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)

### Running the Workflow

#### Option 1: Automatic Trigger (Recommended)
1. Make changes to files in the `eks/` directory
2. Create a pull request
3. Review the Terraform plan in the PR comments
4. Merge to `main` to apply changes

#### Option 2: Manual Trigger
1. Go to **Actions** tab in GitHub
2. Select **EKS Terraform Deployment** workflow
3. Click **Run workflow**
4. Select the action (`plan`, `apply`, or `destroy`)
5. Click **Run workflow**

## 💻 Local Development

### Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.9.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- Appropriate IAM permissions

### Commands

```bash
# Initialize Terraform
terraform init

# Format Terraform files
terraform fmt

# Validate configuration
terraform validate

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy
```

## 📊 Outputs

After successful deployment, the following outputs are available:

- **`cluster_name`**: Name of the EKS cluster
- **`cluster_endpoint`**: API endpoint for the EKS cluster

To view outputs:
```bash
terraform output
```

## 🔐 Security Considerations

1. **OIDC Authentication**: Uses OpenID Connect for secure, keyless authentication with AWS
2. **IAM Roles**: Follows principle of least privilege
3. **VPC Isolation**: Resources are deployed in a dedicated VPC
4. **Node Security**: Worker nodes have minimal required permissions

## 🔄 Updating the Cluster

To update the EKS cluster or node groups:

1. Modify the relevant `.tf` files
2. Create a pull request
3. Review the plan
4. Merge to apply changes

## 🗑️ Destroying the Infrastructure

**⚠️ Warning**: This will delete all resources including the EKS cluster and all running workloads!

### Via GitHub Actions:
1. Go to **Actions** → **EKS Terraform Deployment**
2. Click **Run workflow**
3. Select `destroy` action
4. Confirm and run

### Via Local CLI:
```bash
cd eks/
terraform destroy
```

## 📚 Additional Resources

- [Amazon EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [EKS Best Practices Guide](https://aws.github.io/aws-eks-best-practices/)

## 🐛 Troubleshooting

### Common Issues

1. **OIDC Authentication Failed**
   - Verify `AWS_ROLE_ARN` secret is correctly configured
   - Ensure OIDC provider is set up in AWS

2. **Insufficient Permissions**
   - Check IAM role has required permissions for EKS, EC2, and VPC

3. **Resource Already Exists**
   - Check if resources with the same name already exist
   - Import existing resources or use different names

## 📝 Notes

- The workflow uses Terraform state stored in the default local backend
- For production use, consider using a remote backend (S3 + DynamoDB)
- The cluster is deployed in `ap-south-1` region by default
- Modify `provider.tf` to change the region
