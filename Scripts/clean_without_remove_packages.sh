#!/bin/bash

DERIVED_DIR=~/Library/Developer/Xcode/DerivedData

echo "🔍 Scanning Xcode DerivedData for available projects..."

# 1. List all folders inside DerivedData
PROJECTS=($(ls -1 "$DERIVED_DIR"))
if [ ${#PROJECTS[@]} -eq 0 ]; then
    echo "❌ No project folders found in $DERIVED_DIR"
    exit 1
fi

# 2. Show selectable menu
echo ""
echo "Please select a project to clean build cache (SwiftPM packages will be preserved):"
select PROJECT in "${PROJECTS[@]}"; do
    if [[ -n "$PROJECT" ]]; then
        TARGET_DIR="$DERIVED_DIR/$PROJECT"
        echo ""
        echo "✅ Selected project: $PROJECT"
        echo "📁 Path: $TARGET_DIR"
        echo ""

        # 3. Confirm before cleaning
        read -p "Are you sure you want to remove build cache but keep SwiftPM checkouts? (y/n): " confirm
        if [[ "$confirm" == "y" ]]; then
            rm -rf "$TARGET_DIR/Build/Intermediates.noindex"
            rm -rf "$TARGET_DIR/Build/Products"
            rm -rf "$TARGET_DIR/Index.noindex"
            rm -rf "$TARGET_DIR/IndexBuildLogs"

            echo "✅ Done! Build cache has been cleaned. SwiftPM packages are intact."
        else
            echo "🚫 Operation cancelled."
        fi
        break
    else
        echo "❌ Invalid selection. Please try again."
    fi
done