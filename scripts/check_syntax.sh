#!/bin/bash
# Check all GDScript files for syntax errors

GODOT_PATH="${GODOT_PATH:-godot}"
PROJECT_PATH="${1:-.}"

echo "Using Godot: $GODOT_PATH"
echo "Project: $PROJECT_PATH"
echo "---"

errors=0
checked=0

# Find all .gd files and check each one
while IFS= read -r -d '' file; do
    # Convert to res:// path
    rel_path="${file#$PROJECT_PATH/}"
    res_path="res://$rel_path"

    checked=$((checked + 1))

    # Run Godot check
    output=$("$GODOT_PATH" --headless --path "$PROJECT_PATH" --script "$res_path" --check-only 2>&1)

    # Check for errors in output
    if echo "$output" | grep -q "SCRIPT ERROR\|Parse Error\|Compile Error"; then
        echo "FAIL: $rel_path"
        echo "$output" | grep -E "SCRIPT ERROR|Parse Error|Compile Error|at:"
        echo ""
        errors=$((errors + 1))
    else
        echo "OK: $rel_path"
    fi
done < <(find "$PROJECT_PATH" -name "*.gd" -type f -print0 | grep -zv ".godot")

echo "---"
echo "Checked: $checked files"
echo "Errors: $errors"

exit $errors
