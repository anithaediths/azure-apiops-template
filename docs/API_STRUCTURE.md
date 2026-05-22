# API Structure Guide

## Directory Organization

APIs are organized in `src/apis/` with the following structure:

```
src/apis/
├── petstore/
│   ├── v1/
│   │   ├── definition.yaml
│   │   ├── policies/
│   │   │   ├── api.xml
│   │   │   └── operations/
│   │   │       ├── GET-pets.xml
│   │   │       └── POST-pets.xml
│   │   └── examples/
│   │       └── request.json
│   └── v2/
│       ├── definition.yaml
│       └── policies/
├── users-api/
│   ├── v1/
│   │   └── definition.yaml
│   └── v2/
│       └── definition.yaml
```

## API Definition File

Each API version must have a `definition.yaml` file:

```yaml
name: "petstore"
apiVersion: "1.0.0"
version: "v1"
protocols:
  - https
serviceUrl: "https://petstore-backend.azurewebsites.net"
path: "/api/v1/pets"
displayName: "Petstore API"
description: "API for managing pet store"
contact:
  name: "API Support"
  url: "https://example.com/support"
  email: "api-support@example.com"

operations:
  - method: "GET"
    path: "/"
    name: "List Pets"
    description: "Get all pets"
  - method: "POST"
    path: "/"
    name: "Create Pet"
    description: "Create a new pet"
  - method: "GET"
    path: "/{id}"
    name: "Get Pet"
    description: "Get a specific pet"
```

## API Definition Fields

### Required Fields

- **name**: Unique identifier for the API
- **version**: Version number (e.g., 1.0.0)
- **path**: URL path for the API
- **serviceUrl**: Backend service URL

### Optional Fields

- **description**: API description
- **displayName**: User-friendly name
- **contact**: Contact information
- **license**: License information
- **terms**: Terms of service
- **operations**: List of API operations

## Naming Conventions

### Directory Names
- Use lowercase letters
- Use hyphens for separators
- No spaces or special characters
- Examples: `petstore`, `users-api`, `orders-service`

### API Names
- Use descriptive names
- Include resource type (e.g., `-api`, `-service`)
- Examples: `petstore-api`, `user-management-api`

### Operation Files
- Use HTTP method and path
- Format: `{METHOD}-{path}.xml`
- Examples: `GET-pets.xml`, `POST-users.xml`, `PUT-users-{id}.xml`

## Policies

Each API can have:

1. **API-level policies** (`api.xml`)
   - Applied to all operations
   - Common authentication, rate limiting

2. **Operation-level policies** (`operations/{METHOD}-{path}.xml`)
   - Applied to specific operations
   - Operation-specific transformations

## Example Policy File

### api.xml (API-level)
```xml
<policies>
  <inbound>
    <rate-limit-by-key calls="1000" renewal-period="60" counter-key="@(context.Request.Headers.GetValueOrDefault(\"Authorization\", \"\").AsJwt()?.Subject)" />
    <base />
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>
```

## Product Association

APIs are grouped into products. Define product associations in `src/products/`:

```yaml
productName: "starter"
apiNames:
  - "petstore"
  - "users-api"
subscriptionRequired: false
approvalRequired: false
```

## Versioning

Support multiple API versions:

```
src/apis/petstore/
├── v1/
│   ├── definition.yaml
│   └── policies/
├── v2/
│   ├── definition.yaml
│   └── policies/
└── v3/
    ├── definition.yaml
    └── policies/
```

## Best Practices

1. **One API per directory**
2. **Separate versioning clearly**
3. **Use semantic versioning**
4. **Document operations thoroughly**
5. **Keep policies modular**
6. **Use examples for common scenarios**

## Validation

Validate your API structure:

```bash
bash scripts/validate.sh
```

This checks:
- YAML syntax
- Required fields
- Naming conventions
- Directory structure
