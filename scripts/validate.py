#!/usr/bin/env python3

"""
Validate API definitions and policies
"""

import os
import sys
import yaml
from pathlib import Path

def validate_api_definition(filepath):
    """Validate an API definition file"""
    try:
        with open(filepath, 'r') as f:
            data = yaml.safe_load(f)
        
        if data is None:
            return True
        
        # Check required fields if data exists
        required_fields = ['name', 'apiVersion']
        for field in required_fields:
            if field not in data:
                print(f"❌ Missing required field '{field}' in {filepath}")
                return False
        
        return True
    except yaml.YAMLError as e:
        print(f"❌ YAML parsing error in {filepath}: {e}")
        return False
    except Exception as e:
        print(f"❌ Error validating {filepath}: {e}")
        return False

def main():
    """Main validation function"""
    api_dir = Path('src/apis')
    errors = 0
    
    print("🔍 Validating API definitions...")
    
    if not api_dir.exists():
        print("✅ No API definitions to validate yet")
        sys.exit(0)
    
    for definition_file in api_dir.rglob('definition.yaml'):
        if not validate_api_definition(str(definition_file)):
            errors += 1
    
    for definition_file in api_dir.rglob('definition.yml'):
        if not validate_api_definition(str(definition_file)):
            errors += 1
    
    if errors > 0:
        print(f"\n❌ Found {errors} validation error(s)")
        sys.exit(1)
    else:
        print("✅ All API definitions are valid")
        sys.exit(0)

if __name__ == '__main__':
    main()
