# Azure API Operations - Complete Scaffold

Complete project scaffold and initialization for Azure API Management Operations repository.

## Quick Start

### Create a New Project

```bash
bash scripts/scaffold.sh \
  --project-name myapi \
  --org-name acme \
  --region eastus \
  --environment dev
```

### Initialize the Environment

```bash
bash scripts/setup.sh
source venv/bin/activate
```

### Configure Azure

```bash
cp .env.example .env
vim .env  # Add your Azure credentials
```

### Verify Setup

```bash
make health-check
```

## Scaffold Parameters

### Required
- `--project-name` - Project name (e.g., myapi, user-service)
- `--org-name` - Organization name (e.g., acme)

### Optional
- `--region` - Azure region (default: eastus)
- `--environment` - dev, staging, or prod (default: dev)
- `--api-version` - API version (default: 1.0.0)
- `--sku` - APIM SKU: Developer, Standard, Premium (default: Standard)
- `--capacity` - APIM capacity (default: 1)

## What Gets Generated

### Directory Structure

```
projects/<environment>/<project-name>/
├── config.yml              # Project configuration
├── apis/                   # API definitions (YAML)
├── policies/               # API policies (XML)
├── products/               # Product definitions (YAML)
├── backends/               # Backend configurations
├── schemas/                # JSON schemas
├── examples/               # Example files
├── terraform/              # Terraform IaC
└── bicep/                  # Bicep IaC

src/<project-name>/
├── __init__.py
├── config.py              # Project configuration module
├── models/                # Data models
├── handlers/              # Request handlers
└── validators/            # Validation logic

docs/<project-name>/
├── README.md              # Project README
├── api/                   # API documentation
└── deployment/            # Deployment guides
```

### Configuration Files

- `projects/<env>/<project>/config.yml` - Project configuration
- `.env.example` - Environment variables template
- `src/<project>/config.py` - Python configuration module
- `.github/workflows/` - GitHub Actions workflows

### Examples

- `projects/<env>/<project>/apis/example-api.yml` - Example API
- `projects/<env>/<project>/policies/example-policies.xml` - Example policies
- `projects/<env>/<project>/products/example-product.yml` - Example product
- `projects/<env>/<project>/examples/openapi.yml` - OpenAPI specification

## Project Management

### List Projects

```bash
bash scripts/project-management/list-projects.sh
```

### Add API

```bash
bash scripts/project-management/add-api.sh myapi dev users-api
```

### Add Product

```bash
bash scripts/project-management/add-product.sh myapi dev starter
```

## Examples

### Example 1: Dev Environment

```bash
bash scripts/scaffold.sh \
  --project-name myapi \
  --org-name acme \
  --region eastus \
  --environment dev
```

### Example 2: Production Environment

```bash
bash scripts/scaffold.sh \
  --project-name myapi \
  --org-name acme \
  --region eastus \
  --environment prod \
  --sku Premium \
  --capacity 2 \
  --api-version 2.0.0
```

### Example 3: Staging Environment

```bash
bash scripts/scaffold.sh \
  --project-name microservice \
  --org-name acme \
  --region westus \
  --environment staging \
  --sku Standard \
  --capacity 1
```

## File Descriptions

### Scaffold Scripts

- `scaffold.sh` - Main entry point for project generation
- `scaffold/create-directories.sh` - Create directory structure
- `scaffold/create-config-files.sh` - Generate configuration files
- `scaffold/create-python-modules.sh` - Create Python modules
- `scaffold/create-examples.sh` - Generate example files
- `scaffold/create-documentation.sh` - Create documentation
- `scaffold/create-workflows.sh` - Create GitHub Actions workflows
- `validate-scaffold.sh` - Validate generated structure

### Project Management Scripts

- `project-management/list-projects.sh` - List all projects
- `project-management/add-api.sh` - Add new API
- `project-management/add-product.sh` - Add new product

## Configuration Structure

### Project Config (config.yml)

```yaml
project:
  name: "myapi"
  display_name: "My API"
  organization: "acme"
  version: "1.0.0"
  environment: "dev"
  description: "API Management project"

azure:
  region: "eastus"
  resource_group: "rg-apim-dev-myapi"
  apim:
    name: "apim-dev-myapi"
    display_name: "My API"
    publisher_name: "acme"
    sku: "Standard"
    capacity: 1

apis:
  path: "./apis"
  schema: "openapi3"

policies:
  path: "./policies"
  global: "global.xml"

products:
  path: "./products"
```

### Environment Variables (.env)

```bash
AZURE_SUBSCRIPTION_ID="your-subscription-id"
AZURE_TENANT_ID="your-tenant-id"
AZURE_CLIENT_ID="your-client-id"
AZURE_CLIENT_SECRET="your-client-secret"

PROJECT_NAME="myapi"
PROJECT_ENVIRONMENT="dev"
PROJECT_REGION="eastus"

APIM_NAME="apim-dev-myapi"
APIM_RESOURCE_GROUP="rg-apim-dev-myapi"
```

## Workflow

1. **Generate Scaffold**
   ```bash
   bash scripts/scaffold.sh --project-name myapi --org-name acme
   ```

2. **Setup Environment**
   ```bash
   bash scripts/setup.sh
   source venv/bin/activate
   ```

3. **Configure**
   ```bash
   cp .env.example .env
   vim .env
   ```

4. **Verify**
   ```bash
   make health-check
   bash scripts/validate-scaffold.sh
   ```

5. **Develop**
   ```bash
   bash scripts/dev-setup.sh
   make test
   ```

6. **Deploy**
   ```bash
   make deploy
   ```

## Validation

Validate the generated scaffold:

```bash
bash scripts/validate-scaffold.sh
```

This checks:
- Directory structure
- Configuration files
- Python modules
- Documentation
- GitHub workflows

## Next Steps

1. Review generated `projects/<env>/<project>/config.yml`
2. Add your APIs using `scripts/project-management/add-api.sh`
3. Create products using `scripts/project-management/add-product.sh`
4. Configure policies in `projects/<env>/<project>/policies/`
5. Deploy using `make deploy`

See individual documentation files for detailed information:
- `docs/<project>/README.md` - Project overview
- `docs/<project>/api/API.md` - API documentation
- `docs/<project>/deployment/DEPLOYMENT.md` - Deployment guide
