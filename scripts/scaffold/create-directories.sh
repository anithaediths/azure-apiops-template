#!/bin/bash

# create-directories.sh - Create project directory structure

set -e

PROJECT_NAME=$1
ORG_NAME=$2
ENVIRONMENT=$3

echo "Creating directory structure..."
echo ""

# Create main project directories
mkdir -p "projects/$ENVIRONMENT/$PROJECT_NAME"
mkdir -p "projects/$ENVIRONMENT/$PROJECT_NAME/apis"
mkdir -p "projects/$ENVIRONMENT/$PROJECT_NAME/policies"
mkdir -p "projects/$ENVIRONMENT/$PROJECT_NAME/products"
mkdir -p "projects/$ENVIRONMENT/$PROJECT_NAME/backends"
mkdir -p "projects/$ENVIRONMENT/$PROJECT_NAME/schemas"
mkdir -p "projects/$ENVIRONMENT/$PROJECT_NAME/examples"

# Create environment-specific directories
mkdir -p "projects/$ENVIRONMENT/$PROJECT_NAME/terraform"
mkdir -p "projects/$ENVIRONMENT/$PROJECT_NAME/bicep"
mkdir -p "projects/$ENVIRONMENT/$PROJECT_NAME/scripts"

# Create source code directories
mkdir -p "src/$PROJECT_NAME"
mkdir -p "src/$PROJECT_NAME/models"
mkdir -p "src/$PROJECT_NAME/handlers"
mkdir -p "src/$PROJECT_NAME/validators"

# Create documentation directories
mkdir -p "docs/$PROJECT_NAME"
mkdir -p "docs/$PROJECT_NAME/api"
mkdir -p "docs/$PROJECT_NAME/deployment"

# Create CI/CD directories
mkdir -p ".github/workflows"

echo -e "\033[0;32m✓\033[0m Created directory structure"
echo "  projects/$ENVIRONMENT/$PROJECT_NAME/"
echo "  src/$PROJECT_NAME/"
echo "  docs/$PROJECT_NAME/"
echo ""
