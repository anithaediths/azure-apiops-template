# Deployment Guide

## Overview

Deployments are managed through:
1. Local development scripts
2. GitHub Actions CI/CD pipeline
3. Terraform infrastructure provisioning

## Local Deployment

### Prerequisites

```bash
# Authenticate with Azure
az login
az account set --subscription <SUBSCRIPTION_ID>

# Load environment variables
source .env
```

### Deploy to Development

```bash
bash scripts/deploy.sh --environment dev
```

### Deploy to Staging

```bash
bash scripts/deploy.sh --environment staging
```

### Deploy to Production

```bash
bash scripts/deploy.sh --environment prod
```

## GitHub Actions CI/CD

Automated workflows trigger on:
- Pull requests (validation)
- Merge to main (build and deploy)

### Workflow Files

- **validate.yml**: Validates PRs
- **build-deploy.yml**: Builds and deploys

### Pipeline Stages

1. **Validate**
   - YAML syntax checking
   - API definition validation
   - Naming convention checks

2. **Build**
   - Artifact preparation
   - Configuration processing

3. **Deploy to Dev**
   - Deploy infrastructure
   - Deploy APIs and policies
   - Run integration tests

4. **Deploy to Prod**
   - Manual approval required
   - Deploy to production environment
   - Verify deployment

## Infrastructure Deployment

### Terraform Deployment

```bash
cd infrastructure/terraform

# Plan deployment
terraform plan -var="environment=dev" -out=tfplan

# Apply changes
terraform apply tfplan
```

### Bicep Deployment

```bash
az deployment group create \
  --resource-group rg-apim-dev \
  --template-file infrastructure/bicep/main.bicep \
  --parameters environment=dev
```

## Deployment Checklist

- [ ] Environment variables configured
- [ ] Azure authentication verified
- [ ] Code validated locally
- [ ] All tests passing
- [ ] API definitions updated
- [ ] Policies tested
- [ ] Infrastructure plan reviewed
- [ ] Backup created (for prod)
- [ ] Deployment approved (for prod)

## Rollback

In case of deployment issues:

### Infrastructure Rollback

```bash
cd infrastructure/terraform
terraform destroy -var="environment=dev"
```

### API Rollback

```bash
# Using Azure CLI
az apim api delete \
  --resource-group rg-apim-dev \
  --service-name apim-dev \
  --api-id petstore-v1
```

## Monitoring Deployments

### Check Deployment Status

```bash
# Terraform state
terraform show

# Azure resources
az resource list --resource-group rg-apim-dev

# APIM APIs
az apim api list \
  --resource-group rg-apim-dev \
  --service-name apim-dev
```

## Troubleshooting

### Deployment Failures

1. Check logs in GitHub Actions
2. Run validation locally
3. Review recent changes
4. Check Azure resource limits
5. Verify authentication

### Common Issues

**Issue**: Terraform state lock
```bash
terraform force-unlock <LOCK_ID>
```

**Issue**: Azure quota exceeded
- Check resource quotas in Azure Portal
- Request quota increase if needed

## Deployment Secrets

Store sensitive data in GitHub Secrets:

```bash
# Example secrets to configure
AZURE_CREDENTIALS
AZURE_SUBSCRIPTION_ID
API_MANAGEMENT_KEY
```

Reference in workflows:
```yaml
with:
  creds: ${{ secrets.AZURE_CREDENTIALS }}
```
