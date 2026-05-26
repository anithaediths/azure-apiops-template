#!/bin/bash

# list-projects.sh - List all generated projects and their configurations

echo "================================================"
echo "API Operations Projects"
echo "================================================"
echo ""

if [ ! -d "projects" ]; then
    echo "No projects found. Run scaffold to create a project."
    exit 1
fi

echo "Available Projects:"
echo ""

for env_dir in projects/*/; do
    if [ ! -d "$env_dir" ]; then
        continue
    fi
    
    ENV=$(basename "$env_dir")
    
    for project_dir in "$env_dir"*/; do
        if [ ! -d "$project_dir" ]; then
            continue
        fi
        
        PROJECT=$(basename "$project_dir")
        CONFIG_FILE="$project_dir/config.yml"
        
        echo "Environment: $ENV"
        echo "Project: $PROJECT"
        
        if [ -f "$CONFIG_FILE" ]; then
            API_COUNT=$(grep -c "^  - id:" "$project_dir/apis"/*.yml 2>/dev/null || echo "0")
            PRODUCT_COUNT=$(grep -c "^  - id:" "$project_dir/products"/*.yml 2>/dev/null || echo "0")
            
            echo "  APIs: $API_COUNT"
            echo "  Products: $PRODUCT_COUNT"
            echo "  Config: $CONFIG_FILE"
        fi
        
        echo ""
    done
done

echo "To view project details, use:"
echo "  cat projects/<environment>/<project>/config.yml"
echo ""
