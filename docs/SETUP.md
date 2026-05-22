# Setup Guide for Azure APIOps

## Prerequisites

Before starting, ensure you have:

- Azure subscription
- Azure CLI installed
- Terraform v1.0+ (optional, for infrastructure deployment)
- Git
- Python 3.8+
- GitHub account

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/anithaediths/azure-apiops-template.git
cd azure-apiops-template
```

### 2. Run Setup Script

```bash
bash scripts/setup.sh
```

This will:
- Check prerequisites
- Create `.env` file
- Create project directories
- Install dependencies

### 3. Configure Environment

Edit `.env` file with your Azure configuration:

```bash
vi .env
```

Required variables:
- `AZURE_SUBSCRIPTION_ID`: Your Azure subscription ID
- `AZURE_RESOURCE_GROUP`: Resource group name
- `AZURE_REGION`: Azure region (e.g., eastus)
- `APIM_NAME`: API Management instance name
- `APIM_PUBLISHER_NAME`: Your organization name
- `APIM_PUBLISHER_EMAIL`: Publisher email

### 4. Authenticate with Azure

```bash
az login
az account set --subscription <YOUR_SUBSCRIPTION_ID>
```

### 5. Initialize Terraform Backend (Optional)

```bash
cd infrastructure/terraform
terraform init
cd ../..
```

## First Deployment

### Development Environment

```bash
bash scripts/deploy.sh --environment dev
```

### Staging Environment

```bash
bash scripts/deploy.sh --environment staging
```

### Production Environment

```bash
bash scripts/deploy.sh --environment prod
```

## Verify Installation

```bash
# Check Azure CLI authentication
az account show

# Test Python environment
python3 -c "import yaml; print('Python setup OK')"
```

## Next Steps

1. Read [API Structure](API_STRUCTURE.md) guide
2. Create your first API
3. Define policies
4. Deploy to development
5. Test APIs

## Troubleshooting

### Azure CLI Issues

```bash
# Re-authenticate
az logout
az login

# Check current subscription
az account show
```

### Python Dependency Issues

```bash
# Reinstall dependencies
pip install --upgrade pyyaml jsonschema yamllint
```

## Getting Help

Refer to:
- [Azure Docs](https://docs.microsoft.com/azure/)
- [Terraform Docs](https://www.terraform.io/docs/)
- [API Management Docs](https://docs.microsoft.com/azure/api-management/)
