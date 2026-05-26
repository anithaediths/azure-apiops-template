#!/bin/bash

# add-api.sh - Add a new API to an existing project

set -e

if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ -z "$1" ]; then
    echo "Add a new API to the project"
    echo ""
    echo "Usage: bash scripts/project-management/add-api.sh <project-name> <environment> <api-name>"
    echo ""
    echo "Example: bash scripts/project-management/add-api.sh myapi dev users-api"
    echo ""
    exit 0
fi

PROJECT_NAME=$1
ENVIRONMENT=${2:-dev}
API_NAME=$3

if [ -z "$PROJECT_NAME" ] || [ -z "$API_NAME" ]; then
    echo "Error: project-name and api-name required"
    exit 1
fi

API_ID=$(echo "$API_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
PROJECT_DIR="projects/$ENVIRONMENT/$PROJECT_NAME"
API_FILE="$PROJECT_DIR/apis/${API_ID}.yml"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Project directory not found: $PROJECT_DIR"
    exit 1
fi

echo "Creating new API: $API_NAME ($API_ID)"
echo ""

# Create API definition file
cat > "$API_FILE" << EOF
# API Definition: $API_NAME
# Created: $(date)

apis:
  - id: "${API_ID}-v1"
    name: "$API_ID"
    displayName: "$API_NAME v1"
    description: "API for $API_NAME"
    serviceUrl: "https://your-service.example.com"
    path: "/$API_ID"
    version: "v1"
    protocols:
      - https
    operations:
      - name: "GetAll"
        method: "GET"
        urlTemplate: "/"
        displayName: "Get All"
        description: "Retrieve all resources"
      - name: "Create"
        method: "POST"
        urlTemplate: "/"
        displayName: "Create"
        description: "Create a new resource"
      - name: "GetById"
        method: "GET"
        urlTemplate: "/{id}"
        displayName: "Get by ID"
        description: "Retrieve a specific resource"
      - name: "Update"
        method: "PUT"
        urlTemplate: "/{id}"
        displayName: "Update"
        description: "Update a resource"
      - name: "Delete"
        method: "DELETE"
        urlTemplate: "/{id}"
        displayName: "Delete"
        description: "Delete a resource"
EOF

echo "✓ API definition created: $API_FILE"
echo ""
echo "Next steps:"
echo "1. Edit the API definition: vim $API_FILE"
echo "2. Add policies if needed"
echo "3. Create products that reference this API"
echo "4. Deploy: make deploy"
echo ""
