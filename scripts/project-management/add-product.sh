#!/bin/bash

# add-product.sh - Add a new product to an existing project

set -e

if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ -z "$1" ]; then
    echo "Add a new product to the project"
    echo ""
    echo "Usage: bash scripts/project-management/add-product.sh <project-name> <environment> <product-name>"
    echo ""
    echo "Example: bash scripts/project-management/add-product.sh myapi dev starter"
    echo ""
    exit 0
fi

PROJECT_NAME=$1
ENVIRONMENT=${2:-dev}
PRODUCT_NAME=$3

if [ -z "$PROJECT_NAME" ] || [ -z "$PRODUCT_NAME" ]; then
    echo "Error: project-name and product-name required"
    exit 1
fi

PRODUCT_ID=$(echo "$PRODUCT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
PROJECT_DIR="projects/$ENVIRONMENT/$PROJECT_NAME"
PRODUCT_FILE="$PROJECT_DIR/products/${PRODUCT_ID}.yml"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Project directory not found: $PROJECT_DIR"
    exit 1
fi

echo "Creating new product: $PRODUCT_NAME ($PRODUCT_ID)"
echo ""

# Create product definition file
cat > "$PRODUCT_FILE" << EOF
# Product Definition: $PRODUCT_NAME
# Created: $(date)

products:
  - id: "$PRODUCT_ID"
    name: "$PRODUCT_ID"
    displayName: "$PRODUCT_NAME"
    description: "$PRODUCT_NAME product tier"
    published: true
    subscriptionRequired: true
    approvalRequired: false
    apis: []
    # Add API IDs here:
    # apis:
    #   - "api-v1"
    policies:
      - name: "rate-limit"
        scope: "product"
        calls: 100
        renewal_period: 3600
EOF

echo "✓ Product definition created: $PRODUCT_FILE"
echo ""
echo "Next steps:"
echo "1. Edit the product definition: vim $PRODUCT_FILE"
echo "2. Add API IDs to the apis list"
echo "3. Configure policies as needed"
echo "4. Deploy: make deploy"
echo ""
