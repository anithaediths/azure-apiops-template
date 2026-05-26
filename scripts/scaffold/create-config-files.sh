#!/bin/bash

# create-config-files.sh - Create configuration files for the project

set -e

PROJECT_NAME=$1
PROJECT_NORMALIZED=$2
ORG_NAME=$3
ORG_NORMALIZED=$4
REGION=$5
ENVIRONMENT=$6
API_VERSION=$7
SKU=$8
CAPACITY=$9

echo "Creating configuration files..."
echo ""

PROJECT_DIR="projects/$ENVIRONMENT/$PROJECT_NORMALIZED"

# Create main config.yml
cat > "$PROJECT_DIR/config.yml" << EOF
# $PROJECT_NAME - API Operations Configuration
# Environment: $ENVIRONMENT
# Generated: $(date)

project:
  name: "$PROJECT_NAME"
  display_name: "$PROJECT_NAME API"
  organization: "$ORG_NAME"
  version: "$API_VERSION"
  environment: "$ENVIRONMENT"
  description: "API Management project for $PROJECT_NAME"

azure:
  region: "$REGION"
  resource_group: "rg-apim-${ENVIRONMENT}-${PROJECT_NORMALIZED}"
  apim:
    name: "apim-${ENVIRONMENT}-${PROJECT_NORMALIZED}"
    display_name: "$PROJECT_NAME API"
    publisher_name: "$ORG_NAME"
    publisher_email: "api-team@${ORG_NORMALIZED}.com"
    sku: "$SKU"
    capacity: $CAPACITY
    location: "$REGION"

apis:
  path: "./apis"
  schema: "openapi3"

policies:
  path: "./policies"
  global: "global.xml"

products:
  path: "./products"

backends:
  path: "./backends"

notification:
  enabled: true
  email:
    publisher: "api-team@${ORG_NORMALIZED}.com"
EOF

echo -e "\033[0;32m✓\033[0m Created config.yml"

# Create .env.example
cat > ".env.example" << EOF
# Azure Configuration
AZURE_SUBSCRIPTION_ID="your-subscription-id"
AZURE_TENANT_ID="your-tenant-id"
AZURE_CLIENT_ID="your-client-id"
AZURE_CLIENT_SECRET="your-client-secret"

# Project Configuration
PROJECT_NAME="$PROJECT_NAME"
PROJECT_ENVIRONMENT="$ENVIRONMENT"
PROJECT_REGION="$REGION"

# APIM Configuration
APIM_NAME="apim-${ENVIRONMENT}-${PROJECT_NORMALIZED}"
APIM_RESOURCE_GROUP="rg-apim-${ENVIRONMENT}-${PROJECT_NORMALIZED}"
APIM_SKU="$SKU"
APIM_CAPACITY="$CAPACITY"

# Organization
ORGANIZATION_NAME="$ORG_NAME"
API_PUBLISHER_EMAIL="api-team@${ORG_NORMALIZED}.com"

# Backend Service
BACKEND_SERVICE_URL="https://your-backend.azurewebsites.net"

# Logging
LOG_LEVEL="INFO"
LOG_RETENTION_DAYS="30"

# GitHub (for CI/CD)
GITHUB_TOKEN="your-github-token"
GITHUB_REPOSITORY="your-github-org/$PROJECT_NORMALIZED-apiops"
EOF

echo -e "\033[0;32m✓\033[0m Created .env.example"

# Create project-specific config.py
cat > "src/$PROJECT_NORMALIZED/config.py" << 'EOF'
"""Project-specific configuration."""

import os
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()

class ProjectConfig:
    """Project configuration."""
    
    PROJECT_ROOT = Path(__file__).parent.parent.parent
    PROJECTS_DIR = PROJECT_ROOT / "projects"
    DOCS_DIR = PROJECT_ROOT / "docs"
    SCRIPTS_DIR = PROJECT_ROOT / "scripts"
    
    # Project settings
    PROJECT_NAME = os.getenv("PROJECT_NAME")
    PROJECT_ENVIRONMENT = os.getenv("PROJECT_ENVIRONMENT", "dev")
    PROJECT_REGION = os.getenv("PROJECT_REGION", "eastus")
    
    # Azure
    AZURE_SUBSCRIPTION_ID = os.getenv("AZURE_SUBSCRIPTION_ID")
    AZURE_TENANT_ID = os.getenv("AZURE_TENANT_ID")
    AZURE_CLIENT_ID = os.getenv("AZURE_CLIENT_ID")
    AZURE_CLIENT_SECRET = os.getenv("AZURE_CLIENT_SECRET")
    
    # APIM
    APIM_NAME = os.getenv("APIM_NAME")
    APIM_RESOURCE_GROUP = os.getenv("APIM_RESOURCE_GROUP")
    APIM_SKU = os.getenv("APIM_SKU", "Standard")
    APIM_CAPACITY = int(os.getenv("APIM_CAPACITY", "1"))
    
    # Paths
    CONFIG_FILE = PROJECTS_DIR / PROJECT_ENVIRONMENT / PROJECT_NAME.lower().replace(" ", "-") / "config.yml"
    APIS_DIR = PROJECTS_DIR / PROJECT_ENVIRONMENT / PROJECT_NAME.lower().replace(" ", "-") / "apis"
    POLICIES_DIR = PROJECTS_DIR / PROJECT_ENVIRONMENT / PROJECT_NAME.lower().replace(" ", "-") / "policies"
    PRODUCTS_DIR = PROJECTS_DIR / PROJECT_ENVIRONMENT / PROJECT_NAME.lower().replace(" ", "-") / "products"
EOF

echo -e "\033[0;32m✓\033[0m Created project config.py"

# Create backend definitions
cat > "$PROJECT_DIR/backends/default.yml" << EOF
# Default backend definitions
# Add your backend service definitions here

backends: []
# Example:
# - name: mybackend
#   url: https://mybackend.azurewebsites.net
#   protocol: http
#   tls:
#     validate_certificate_chain: true
#     validate_certificate_name: true
EOF

echo -e "\033[0;32m✓\033[0m Created backend definitions"

# Create policy templates
cat > "$PROJECT_DIR/policies/global.xml" << 'EOF'
<!--
  Global API Management policies
  Applied to all APIs, operations, and products
-->
<policies>
  <inbound>
    <rate-limit-by-key calls="100" renewal-period="60" counter-key="@(context.Request.IpAddress)" />
    <cors allowed-origins="*" allowed-methods="GET,POST,PUT,DELETE,PATCH" allowed-headers="*" expose-headers="*" />
  </inbound>
  <backend>
    <forward-request />
  </backend>
  <outbound>
    <json-to-xml apply="response" />
    <base />
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>
EOF

echo -e "\033[0;32m✓\033[0m Created policy templates"

echo ""
