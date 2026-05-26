#!/bin/bash

# create-python-modules.sh - Create Python module structure

set -e

PROJECT_NAME=$1

echo "Creating Python modules..."
echo ""

# Create __init__.py files
touch "src/$PROJECT_NAME/__init__.py"
touch "src/$PROJECT_NAME/models/__init__.py"
touch "src/$PROJECT_NAME/handlers/__init__.py"
touch "src/$PROJECT_NAME/validators/__init__.py"

echo -e "\033[0;32m✓\033[0m Created __init__.py files"

# Create models module
cat > "src/$PROJECT_NAME/models/__init__.py" << 'EOF'
"""Data models for the project."""

from .api_model import APIModel
from .policy_model import PolicyModel
from .product_model import ProductModel

__all__ = ["APIModel", "PolicyModel", "ProductModel"]
EOF

cat > "src/$PROJECT_NAME/models/api_model.py" << 'EOF'
"""API model definitions."""

from dataclasses import dataclass, field
from typing import List, Optional, Dict, Any


@dataclass
class Operation:
    """API Operation model."""
    name: str
    method: str
    url_template: str
    display_name: str
    description: Optional[str] = None
    policies: Optional[str] = None


@dataclass
class APIModel:
    """API model."""
    id: str
    name: str
    display_name: str
    description: str
    service_url: str
    path: str
    version: Optional[str] = None
    protocols: List[str] = field(default_factory=lambda: ["https"])
    operations: List[Operation] = field(default_factory=list)
    policies: Optional[Dict[str, Any]] = None
EOF

echo -e "\033[0;32m✓\033[0m Created models module"

# Create handlers module
cat > "src/$PROJECT_NAME/handlers/__init__.py" << 'EOF'
"""Handler functions for API operations."""

from .api_handler import APIHandler
from .policy_handler import PolicyHandler

__all__ = ["APIHandler", "PolicyHandler"]
EOF

cat > "src/$PROJECT_NAME/handlers/api_handler.py" << 'EOF'
"""API operation handlers."""

from typing import Optional, List
from src.apis import APIManager
from ..models import APIModel


class APIHandler:
    """Handles API operations."""
    
    def __init__(self, settings):
        """Initialize handler."""
        self.settings = settings
        self.api_manager = APIManager(settings)
    
    def create_api(self, api: APIModel) -> bool:
        """Create API."""
        return self.api_manager.validate_api_definition(api)
    
    def list_apis(self) -> Optional[List]:
        """List APIs."""
        return self.api_manager.get_apis()
EOF

echo -e "\033[0;32m✓\033[0m Created handlers module"

# Create validators module
cat > "src/$PROJECT_NAME/validators/__init__.py" << 'EOF'
"""Validation functions."""

from .api_validator import validate_api
from .policy_validator import validate_policy

__all__ = ["validate_api", "validate_policy"]
EOF

cat > "src/$PROJECT_NAME/validators/api_validator.py" << 'EOF'
"""API validation."""

from typing import Dict, Any


def validate_api(api_config: Dict[str, Any]) -> bool:
    """Validate API configuration."""
    required_fields = ['id', 'name', 'service_url', 'path']
    return all(field in api_config for field in required_fields)
EOF

cat > "src/$PROJECT_NAME/validators/policy_validator.py" << 'EOF'
"""Policy validation."""

from typing import Dict, Any


def validate_policy(policy_config: Dict[str, Any]) -> bool:
    """Validate policy configuration."""
    required_fields = ['id', 'name', 'scope', 'content']
    return all(field in policy_config for field in required_fields)
EOF

echo -e "\033[0;32m✓\033[0m Created validators module"

echo ""
