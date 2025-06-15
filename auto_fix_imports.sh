#!/bin/bash

# Automatically fix import extension issues in bolt.diy

echo "🔧 Auto-fixing import extensions..."
echo "=================================="

# Function to fix imports in a file
fix_imports_in_file() {
    local file="$1"
    local search_pattern="$2"
    local replacement="$3"
    local description="$4"
    
    if [[ -f "$file" ]]; then
        if grep -q "$search_pattern" "$file"; then
            echo "  📝 Fixing $description in $file"
            sed -i "s|$search_pattern|$replacement|g" "$file"
            echo "     ✅ Updated"
        else
            echo "  ⏭️  No $description found in $file"
        fi
    else
        echo "  ❌ File not found: $file"
    fi
}

echo ""
echo "1. Fixing BaseChat imports..."
echo "----------------------------"

# Fix BaseChat imports in GitUrlImport.client.tsx
fix_imports_in_file \
    "app/components/git/GitUrlImport.client.tsx" \
    "from '~/components/chat/BaseChat'" \
    "from '~/components/chat/BaseChat.tsx'" \
    "BaseChat import"

# Fix BaseChat imports in Chat.client.tsx
fix_imports_in_file \
    "app/components/chat/Chat.client.tsx" \
    "from './BaseChat'" \
    "from './BaseChat.tsx'" \
    "BaseChat import"

# Fix BaseChat imports in git.tsx route
fix_imports_in_file \
    "app/routes/git.tsx" \
    "from '~/components/chat/BaseChat'" \
    "from '~/components/chat/BaseChat.tsx'" \
    "BaseChat import"

# Fix BaseChat imports in _index.tsx route
fix_imports_in_file \
    "app/routes/_index.tsx" \
    "from '~/components/chat/BaseChat'" \
    "from '~/components/chat/BaseChat.tsx'" \
    "BaseChat import"

echo ""
echo "2. Fixing other common import issues..."
echo "-------------------------------------"

# Fix Messages.client import in BaseChat.tsx
fix_imports_in_file \
    "app/components/chat/BaseChat.tsx" \
    "from './Messages.client'" \
    "from './Messages.client.tsx'" \
    "Messages.client import"

# Fix ChatBox import in BaseChat.tsx
fix_imports_in_file \
    "app/components/chat/BaseChat.tsx" \
    "from './ChatBox'" \
    "from './ChatBox.tsx'" \
    "ChatBox import"

echo ""
echo "3. Verification..."
echo "-----------------"

echo "Checking if fixes were applied correctly:"

# Check BaseChat imports
echo ""
echo "BaseChat imports after fix:"
grep -n "BaseChat" app/components/git/GitUrlImport.client.tsx app/routes/git.tsx app/routes/_index.tsx app/components/chat/Chat.client.tsx 2>/dev/null | grep "from"

echo ""
echo "Other imports in BaseChat.tsx:"
grep -n "from '\\./" app/components/chat/BaseChat.tsx | head -5

echo ""
echo "🎉 Import fixes completed!"
echo "========================="
echo ""
echo "Next steps:"
echo "1. Test the build: pnpm run build"
echo "2. If there are still issues, check the output above"
echo "3. Run the diagnostic script again if needed"
