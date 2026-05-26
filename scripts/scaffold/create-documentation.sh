#!/bin/bash

# create-documentation.sh - Create project documentation

set -e

PROJECT_NAME=$1
PROJECT_DISPLAY_NAME=$2
ORG_NAME=$3

echo "Creating documentation..."
echo ""

# Create main README
cat > "docs/$PROJECT_NAME/README.md" << EOF
# $PROJECT_DISPLAY_NAME - API Operations

This is the API Operations repository for **$PROJECT_DISPLAY_NAME**.

## Overview

This repository contains:
- API definitions and configurations
- API Management policies
- Products and subscriptions
- Backend service configurations
- Infrastructure as Code (IaC)

## Quick Start

### Prerequisites
- Python 3.8+
- Azure CLI
- Terraform or Bicep (optional, for IaC)

### Setup

1. Clone the repository
2. Run setup script:
   \`\`\`bash
   bash scripts/setup.sh
   source venv/bin/activate
   \`\`\`

3. Configure environment:
   \`\`\`bash
   cp .env.example .env
   # Edit .env with your Azure credentials
   \`\`\`

4. Verify setup:
   \`\`\`bash
   make health-check
   \`\`\`

## Project Structure

```
projects/
└── dev/
    └── $PROJECT_NAME/
        ├── config.yml              # Project configuration
        ├── apis/                   # API definitions
        ├── policies/               # API policies
        ├── products/               # Products
        ├── backends/               # Backend services
        ├── schemas/                # JSON schemas
        ├── examples/               # Example files
        ├── terraform/              # Terraform IaC
        └── bicep/                  # Bicep IaC

src/
└── $PROJECT_NAME/              # Project source code
    ├── models/                 # Data models
    ├── handlers/               # Request handlers
    └── validators/             # Validation logic

docs/
└── $PROJECT_NAME/              # Project documentation
    ├── api/                    # API documentation
    └── deployment/             # Deployment guides
```

## API Definitions

API definitions are located in \`projects/dev/$PROJECT_NAME/apis/\`

Example: \`example-api.yml\`

### Creating a New API

1. Create a YAML file in \`projects/dev/$PROJECT_NAME/apis/\`
2. Define API configuration following the example
3. Add operations with HTTP methods and paths
4. Assign policies as needed

## Policies

API Management policies are located in \`projects/dev/$PROJECT_NAME/policies/\`

Common policies:
- Rate limiting
- Authentication/Authorization
- CORS
- Caching
- Request/Response transformation

## Products

Products are located in \`projects/dev/$PROJECT_NAME/products/\`

Products group APIs and manage subscriptions and access policies.

## Deployment

### Manual Deployment

```bash
make deploy
```

### Automated Deployment (CI/CD)

See \`.github/workflows\` for GitHub Actions workflows.

## Documentation

- **API Documentation**: See \`docs/$PROJECT_NAME/api/\`
- **Deployment Guide**: See \`docs/$PROJECT_NAME/deployment/\`
- **Scripts Guide**: See \`docs/SCRIPTS.md\`

## Development

### Code Style

```bash
make format    # Format code
make lint      # Lint code
```

### Testing

```bash
make test      # Run tests
```

### Type Checking

```bash
make type-check  # Type checking
```

## Support

For issues and questions, please contact the API team at api-team@${ORG_NAME}.com
EOF

echo -e "\033[0;32m✓\033[0m Created main README"

# Create API documentation template
cat > "docs/$PROJECT_NAME/api/API.md" << EOF
# API Documentation

## Available APIs

This section documents all available APIs.

### Example API v1

**Base URL**: \`https://api.example.com/example/v1\`

#### Endpoints

##### GET /items
Retrieve all items.

**Query Parameters**:
- \`limit\` (optional): Maximum number of items to return
- \`offset\` (optional): Number of items to skip

**Response**:
\`\`\`json
{
  "items": [
    {
      "id": "string",
      "name": "string",
      "description": "string",
      "status": "active"
    }
  ],
  "total": 0
}
\`\`\`

##### POST /items
Create a new item.

**Request Body**:
\`\`\`json
{
  "name": "string",
  "description": "string"
}
\`\`\`

**Response**: \`201 Created\`

##### GET /items/{id}
Get a specific item by ID.

**Response**: \`200 OK\`

##### PUT /items/{id}
Update an existing item.

**Response**: \`200 OK\`

##### DELETE /items/{id}
Delete an item.

**Response**: \`204 No Content\`

EOF

echo -e "\033[0;32m✓\033[0m Created API documentation"

# Create deployment guide
cat > "docs/$PROJECT_NAME/deployment/DEPLOYMENT.md" << EOF
# Deployment Guide

## Prerequisites

- Azure subscription with appropriate permissions
- Azure CLI installed and configured
- Terraform or Bicep (if using IaC)
- GitHub Actions (for automated deployments)

## Manual Deployment

### 1. Validate Configuration

\`\`\`bash
make validate-env
\`\`\`

### 2. Run Tests

\`\`\`bash
make test
\`\`\`

### 3. Deploy

\`\`\`bash
make deploy
\`\`\`

## Automated Deployment (CI/CD)

GitHub Actions workflows automatically deploy on:
- Push to main branch
- Pull request (staging)
- Manual workflow dispatch

### Workflow Files

- \`.github/workflows/validate.yml\` - Validation and testing
- \`.github/workflows/deploy-dev.yml\` - Deploy to dev environment
- \`.github/workflows/deploy-prod.yml\` - Deploy to production (manual)

## Rollback

To rollback a deployment:

\`\`\`bash
bash scripts/rollback.sh --revision <revision-id>
\`\`\`

## Troubleshooting

### Deployment Fails

1. Check logs: \`make health-check\`
2. Validate environment: \`make validate-env\`
3. Check Azure credentials
4. Review error messages in GitHub Actions workflow

EOF

echo -e "\033[0;32m✓\033[0m Created deployment guide"

# Create getting started guide
cat > "docs/$PROJECT_NAME/deployment/GETTING-STARTED.md" << EOF
# Getting Started

## Step 1: Environment Setup

1. Clone the repository
2. Run setup:
   \`\`\`bash
   bash scripts/setup.sh
   source venv/bin/activate
   \`\`\`

3. Configure .env:
   \`\`\`bash
   cp .env.example .env
   vim .env
   \`\`\`

## Step 2: Add Your APIs

1. Create API definition in \`projects/dev/$PROJECT_NAME/apis/your-api.yml\`
2. Define API operations
3. Add policies if needed

## Step 3: Create Products

1. Define product in \`projects/dev/$PROJECT_NAME/products/\`
2. Link APIs to product
3. Configure subscription policies

## Step 4: Test Locally

\`\`\`bash
make test
\`\`\`

## Step 5: Deploy

\`\`\`bash
make deploy
\`\`\`

## Next Steps

- Review API documentation in \`docs/$PROJECT_NAME/api/\`
- Configure CI/CD in GitHub Actions
- Set up monitoring and alerts
- Create API subscriptions for consumers

EOF

echo -e "\033[0;32m✓\033[0m Created getting started guide"

echo ""
