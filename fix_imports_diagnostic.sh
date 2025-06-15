#!/bin/bash

# Fix import extensions diagnostic script for bolt.diy Cloudflare build issues
# This script finds and analyzes missing file extensions in import statements

echo "🔍 Diagnosing import extension issues in bolt.diy..."
echo "=================================================="

# Function to check if a file exists with different extensions
check_file_exists() {
    local import_path="$1"
    local base_dir="$2"
    
    # Convert import path to file path
    local file_path="${import_path#~/}"
    file_path="${file_path#./}"
    
    # Check for various extensions
    if [[ -f "$base_dir/$file_path.tsx" ]]; then
        echo "  ✅ Found: $base_dir/$file_path.tsx"
        return 0
    elif [[ -f "$base_dir/$file_path.ts" ]]; then
        echo "  ✅ Found: $base_dir/$file_path.ts"
        return 0
    elif [[ -f "$base_dir/$file_path.jsx" ]]; then
        echo "  ✅ Found: $base_dir/$file_path.jsx"
        return 0
    elif [[ -f "$base_dir/$file_path.js" ]]; then
        echo "  ✅ Found: $base_dir/$file_path.js"
        return 0
    elif [[ -f "$base_dir/$file_path/index.tsx" ]]; then
        echo "  ✅ Found: $base_dir/$file_path/index.tsx"
        return 0
    elif [[ -f "$base_dir/$file_path/index.ts" ]]; then
        echo "  ✅ Found: $base_dir/$file_path/index.ts"
        return 0
    else
        echo "  ❌ Not found: $base_dir/$file_path (checked .tsx, .ts, .jsx, .js, index files)"
        return 1
    fi
}

echo "1. Checking BaseChat import issues..."
echo "-----------------------------------"

# Find files importing BaseChat without extension
echo "Files importing BaseChat without extension:"
grep -r "from.*BaseChat['\"]" app/ --include='*.tsx' --include='*.ts' | while read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    import_line=$(echo "$line" | cut -d: -f2-)
    echo "  📄 $file"
    echo "     $import_line"
    
    # Extract the import path
    import_path=$(echo "$import_line" | sed -n "s/.*from ['\"]\\([^'\"]*\\)['\"].*/\\1/p")
    if [[ -n "$import_path" ]]; then
        echo "     Import path: $import_path"
        check_file_exists "$import_path" "app"
    fi
    echo ""
done

echo "2. Checking GitUrlImport import issues..."
echo "---------------------------------------"

# Find files importing GitUrlImport without extension
echo "Files importing GitUrlImport without extension:"
grep -r "from.*GitUrlImport['\"]" app/ --include='*.tsx' --include='*.ts' | while read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    import_line=$(echo "$line" | cut -d: -f2-)
    echo "  📄 $file"
    echo "     $import_line"
    
    # Extract the import path
    import_path=$(echo "$import_line" | sed -n "s/.*from ['\"]\\([^'\"]*\\)['\"].*/\\1/p")
    if [[ -n "$import_path" ]]; then
        echo "     Import path: $import_path"
        check_file_exists "$import_path" "app"
    fi
    echo ""
done

echo "3. Checking all relative imports without extensions..."
echo "---------------------------------------------------"

# Find all relative imports without extensions (more comprehensive)
echo "All relative imports missing extensions:"
grep -r "from ['\"]\\.\\.\\?/" app/ --include='*.tsx' --include='*.ts' | grep -v "\\.tsx['\"]" | grep -v "\\.ts['\"]" | grep -v "\\.jsx['\"]" | grep -v "\\.js['\"]" | grep -v "\\.css['\"]" | grep -v "\\.scss['\"]" | head -20 | while read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    import_line=$(echo "$line" | cut -d: -f2-)
    echo "  📄 $file"
    echo "     $import_line"
    echo ""
done

echo "4. File structure analysis..."
echo "----------------------------"

echo "BaseChat related files:"
find app/ -name "*BaseChat*" -type f

echo ""
echo "GitUrlImport related files:"
find app/ -name "*GitUrlImport*" -type f

echo ""
echo "Chat component directory structure:"
ls -la app/components/chat/ 2>/dev/null || echo "Chat directory not found"

echo ""
echo "Git component directory structure:"
ls -la app/components/git/ 2>/dev/null || echo "Git directory not found"

echo ""
echo "🎯 Summary:"
echo "==========="
echo "The diagnostic is complete. Check the output above to see:"
echo "1. Which files are importing without extensions"
echo "2. Whether the target files actually exist"
echo "3. What the correct file paths should be"
echo ""
echo "Next step: Run the auto-fix script or manually update the imports."
