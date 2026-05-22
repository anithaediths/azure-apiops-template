# Azure APIOps Documentation

This directory contains comprehensive documentation for the Azure APIOps template.

## Table of Contents

- [Setup Guide](SETUP.md) - Initial setup and configuration
- [API Structure](API_STRUCTURE.md) - How to organize your APIs
- [Deployment Guide](DEPLOYMENT.md) - Deployment procedures
- [Best Practices](BEST_PRACTICES.md) - Recommended practices

## Quick Links

### For New Projects
1. Start with [Setup Guide](SETUP.md)
2. Review [API Structure](API_STRUCTURE.md)
3. Follow [Deployment Guide](DEPLOYMENT.md)

### For Existing Projects
1. Review [Best Practices](BEST_PRACTICES.md)
2. Understand the CI/CD Pipeline
3. Check deployment procedures

## Key Concepts

### APIs
API definitions are stored in `src/apis/` organized by API name and version.

### Policies
Policies are defined at three levels:
- **Global**: Applied to all APIs
- **API**: Applied to specific API
- **Operation**: Applied to specific operation

### Products
Products group related APIs for consumer management in `src/products/`

### Infrastructure
Azure resources defined as code in `infrastructure/`:
- Terraform for IaC
- Bicep templates

## Getting Help

For detailed information on specific topics, refer to the individual documentation files.
