#!/bin/bash

# create-examples.sh - Create example files for APIs, policies, and products

set -e

PROJECT_NAME=$1
ORG_NAME=$2
ENVIRONMENT=$(grep '^ENVIRONMENT=' .env.example 2>/dev/null | cut -d'=' -f2 | tr -d '"' || echo "dev")

PROJECT_DIR="projects/$ENVIRONMENT/$PROJECT_NAME"

echo "Creating example files..."
echo ""

# Create example API definition
cat > "$PROJECT_DIR/apis/example-api.yml" << EOF
# Example API Definition
# This demonstrates the structure for defining APIs in API Management

apis:
  - id: "example-api-v1"
    name: "example-api"
    displayName: "Example API v1"
    description: "Example API demonstrating common patterns"
    serviceUrl: "https://api.example.com"
    path: "/example"
    version: "v1"
    protocols:
      - https
    operations:
      - name: "GetItems"
        method: "GET"
        urlTemplate: "/items"
        displayName: "Get Items"
        description: "Retrieve all items"
        policies:
          - name: "rate-limit"
            scope: "operation"
      - name: "CreateItem"
        method: "POST"
        urlTemplate: "/items"
        displayName: "Create Item"
        description: "Create a new item"
      - name: "GetItemById"
        method: "GET"
        urlTemplate: "/items/{id}"
        displayName: "Get Item by ID"
        description: "Get a specific item"
      - name: "UpdateItem"
        method: "PUT"
        urlTemplate: "/items/{id}"
        displayName: "Update Item"
        description: "Update an existing item"
      - name: "DeleteItem"
        method: "DELETE"
        urlTemplate: "/items/{id}"
        displayName: "Delete Item"
        description: "Delete an item"
EOF

echo -e "\033[0;32m✓\033[0m Created example API definition"

# Create example policy definitions
cat > "$PROJECT_DIR/policies/example-policies.xml" << 'EOF'
<!--
  Example Policies
  Common API Management policy patterns
-->

<!-- Rate Limiting Policy -->
<policy name="rate-limit">
  <rate-limit-by-key 
    calls="100" 
    renewal-period="60" 
    counter-key="@(context.Request.IpAddress)" />
</policy>

<!-- Authentication Policy -->
<policy name="validate-jwt">
  <validate-jwt 
    header-name="Authorization" 
    failed-validation-httpcode="401" 
    failed-validation-error-message="Unauthorized">
    <audiences>
      <audience>api://your-api-id</audience>
    </audiences>
    <issuers>
      <issuer>https://sts.windows.net/your-tenant-id/</issuer>
    </issuers>
  </validate-jwt>
</policy>

<!-- CORS Policy -->
<policy name="cors">
  <cors 
    allowed-origins="*" 
    allowed-methods="GET,POST,PUT,DELETE,PATCH,OPTIONS" 
    allowed-headers="*" 
    expose-headers="Content-Length,X-Custom-Header" />
</policy>

<!-- Cache Policy -->
<policy name="cache-get">
  <cache-lookup 
    vary-by-developer="false" 
    vary-by-user="false" 
    vary-by-query-parameter="*" 
    cache-preference="server" />
  <base />
  <cache-store duration="3600" />
</policy>

<!-- Transformation Policy -->
<policy name="json-to-xml">
  <json-to-xml apply="response" />
</policy>
EOF

echo -e "\033[0;32m✓\033[0m Created example policy definitions"

# Create example product definition
cat > "$PROJECT_DIR/products/example-product.yml" << EOF
# Example Product Definition

products:
  - id: "starter"
    name: "Starter"
    displayName: "Starter Product"
    description: "Entry-level product for getting started"
    published: true
    subscriptionRequired: true
    approvalRequired: false
    apis:
      - "example-api-v1"
    policies:
      - name: "rate-limit"
        scope: "product"
        calls: 100
        renewal_period: 3600
  
  - id: "professional"
    name: "Professional"
    displayName: "Professional Product"
    description: "Professional tier with advanced features"
    published: true
    subscriptionRequired: true
    approvalRequired: true
    apis:
      - "example-api-v1"
    policies:
      - name: "rate-limit"
        scope: "product"
        calls: 1000
        renewal_period: 3600
EOF

echo -e "\033[0;32m✓\033[0m Created example product definition"

# Create schema definition
cat > "$PROJECT_DIR/schemas/item.json" << 'EOF'
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Item",
  "description": "An item in the system",
  "type": "object",
  "properties": {
    "id": {
      "type": "string",
      "description": "Unique identifier"
    },
    "name": {
      "type": "string",
      "description": "Item name"
    },
    "description": {
      "type": "string",
      "description": "Item description"
    },
    "status": {
      "type": "string",
      "enum": ["active", "inactive", "archived"],
      "description": "Item status"
    },
    "createdAt": {
      "type": "string",
      "format": "date-time",
      "description": "Creation timestamp"
    },
    "updatedAt": {
      "type": "string",
      "format": "date-time",
      "description": "Last update timestamp"
    }
  },
  "required": ["id", "name", "status"]
}
EOF

echo -e "\033[0;32m✓\033[0m Created schema definitions"

# Create OpenAPI example
cat > "$PROJECT_DIR/examples/openapi.yml" << 'EOF'
openapi: 3.0.0
info:
  title: Example API
  version: 1.0.0
  description: Example API using OpenAPI 3.0 specification
  contact:
    name: API Support
    email: support@example.com
  license:
    name: MIT

servers:
  - url: https://api.example.com
    description: Production environment
  - url: https://api-dev.example.com
    description: Development environment

paths:
  /items:
    get:
      summary: List all items
      operationId: listItems
      parameters:
        - name: limit
          in: query
          description: How many items to return
          required: false
          schema:
            type: integer
            format: int32
      responses:
        '200':
          description: A list of items
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Item'
    post:
      summary: Create a new item
      operationId: createItem
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Item'
      responses:
        '201':
          description: Item created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Item'

  /items/{id}:
    get:
      summary: Get an item by ID
      operationId: getItemById
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Item found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Item'
        '404':
          description: Item not found

components:
  schemas:
    Item:
      type: object
      properties:
        id:
          type: string
        name:
          type: string
        description:
          type: string
        status:
          type: string
          enum: [active, inactive, archived]
        createdAt:
          type: string
          format: date-time
        updatedAt:
          type: string
          format: date-time
      required:
        - id
        - name
        - status
EOF

echo -e "\033[0;32m✓\033[0m Created OpenAPI example"

echo ""
