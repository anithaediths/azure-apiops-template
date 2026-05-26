#!/bin/bash

# scaffold.sh - Generate complete Azure API Operations project structure
# This is the main entry point for creating a new apiops repository
#
# Usage: bash scripts/scaffold.sh --project-name <name> --org-name <org> --region <region>
#
# Example: bash scripts/scaffold.sh --project-name myapi --org-name acme --region eastus

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
PROJECT_NAME=""
ORG_NAME=""
REGION="eastus"
ENVIRONMENT="dev"
API_VERSION="1.0.0"
SKU="Standard"
CAPACITY="1"

# Function to display usage
usage() {
    echo -e "${BLUE}Azure API Operations Scaffold Generator${NC}"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --project-name <name>      Project name (required)"
    echo "  --org-name <name>          Organization name (required)"
    echo "  --region <region>          Azure region (default: eastus)"
    echo "  --environment <env>        Environment: dev, staging, prod (default: dev)"
    echo "  --api-version <version>    API version (default: 1.0.0)"
    echo "  --sku <sku>                APIM SKU: Developer, Standard, Premium (default: Standard)"
    echo "  --capacity <num>           APIM capacity (default: 1)"
    echo "  --help                     Show this help message"
    echo ""
    echo "Example:"
    echo "  $0 --project-name myapi --org-name acme --region eastus --environment dev"
    echo ""
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --project-name)
            PROJECT_NAME="$2"
            shift 2
            ;;
        --org-name)
            ORG_NAME="$2"
            shift 2
            ;;
        --region)
            REGION="$2"
            shift 2
            ;;
        --environment)
            ENVIRONMENT="$2"
            shift 2
            ;;
        --api-version)
            API_VERSION="$2"
            shift 2
            ;;
        --sku)
            SKU="$2"
            shift 2
            ;;
        --capacity)
            CAPACITY="$2"
            shift 2
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            usage
            exit 1
            ;;
    esac
done

# Validate required parameters
if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Error: --project-name is required${NC}"
    usage
    exit 1
fi

if [ -z "$ORG_NAME" ]; then
    echo -e "${RED}Error: --org-name is required${NC}"
    usage
    exit 1
fi

# Validate environment
if [[ ! "dev staging prod" =~ $ENVIRONMENT ]]; then
    echo -e "${RED}Error: Invalid environment. Must be: dev, staging, or prod${NC}"
    exit 1
fi

# Create normalized names
PROJECT_NORMALIZED=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
ORG_NORMALIZED=$(echo "$ORG_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Azure API Operations Scaffold Generator${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${YELLOW}Configuration:${NC}"
echo "  Project Name: $PROJECT_NAME ($PROJECT_NORMALIZED)"
echo "  Organization: $ORG_NAME ($ORG_NORMALIZED)"
echo "  Region: $REGION"
echo "  Environment: $ENVIRONMENT"
echo "  API Version: $API_VERSION"
echo "  APIM SKU: $SKU"
echo "  APIM Capacity: $CAPACITY"
echo ""

# Run sub-scripts to generate structure
echo -e "${YELLOW}Generating project structure...${NC}"
echo ""

bash scripts/scaffold/create-directories.sh "$PROJECT_NORMALIZED" "$ORG_NORMALIZED" "$ENVIRONMENT"
bash scripts/scaffold/create-config-files.sh "$PROJECT_NAME" "$PROJECT_NORMALIZED" "$ORG_NAME" "$ORG_NORMALIZED" "$REGION" "$ENVIRONMENT" "$API_VERSION" "$SKU" "$CAPACITY"
bash scripts/scaffold/create-python-modules.sh "$PROJECT_NORMALIZED"
bash scripts/scaffold/create-examples.sh "$PROJECT_NORMALIZED" "$ORG_NORMALIZED"
bash scripts/scaffold/create-documentation.sh "$PROJECT_NORMALIZED" "$PROJECT_NAME" "$ORG_NAME"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Scaffold Generation Completed!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo ""
echo "1. Initialize Git repository (if new):"
echo -e "   ${BLUE}git init${NC}"
echo ""
echo "2. Setup Python environment:"
echo -e "   ${BLUE}bash scripts/setup.sh${NC}"
echo ""
echo "3. Configure Azure credentials:"
echo -e "   ${BLUE}cp .env.example .env${NC}"
echo -e "   ${BLUE}vim .env${NC}"
echo ""
echo "4. Verify setup:"
echo -e "   ${BLUE}make health-check${NC}"
echo ""
echo "5. Start developing:"
echo -e "   ${BLUE}source venv/bin/activate${NC}"
echo -e "   ${BLUE}bash scripts/dev-setup.sh${NC}"
echo ""
echo -e "${YELLOW}Project Structure:${NC}"
echo "  - projects/$ENVIRONMENT/$PROJECT_NORMALIZED/  : Project configuration"
echo "  - src/                                         : Source code"
echo "  - scripts/                                     : Automation scripts"
echo "  - docs/                                        : Documentation"
echo ""
echo -e "${YELLOW}Configuration Files:${NC}"
echo "  - projects/$ENVIRONMENT/$PROJECT_NORMALIZED/config.yml      : Project config"
echo "  - projects/$ENVIRONMENT/$PROJECT_NORMALIZED/apis/           : API definitions"
echo "  - projects/$ENVIRONMENT/$PROJECT_NORMALIZED/policies/       : Policies"
echo "  - projects/$ENVIRONMENT/$PROJECT_NORMALIZED/products/       : Products"
echo ""
