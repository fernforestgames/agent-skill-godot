---
name: godot
description: "MANDATORY for ALL GDScript/.gd files and Godot resources (.tscn, .tres). Invoke this skill FIRST before writing ANY Godot code—never write GDScript directly without this skill. Provides documentation lookup, syntax checking, and testing instructions."
---

# Godot development

Requires Godot 4 and the `godot` MCP server (npm package `@fernforestgames/mcp-server-godot`) to be installed.

## GDScript workflow

When writing or modifying GDScript, copy this checklist and track your progress:

```
- [ ] Step 1: Read source files
- [ ] Step 2: Look up relevant Godot documentation
- [ ] Step 3: Write or modify GDScript code
- [ ] Step 4: Import new files with Godot CLI
- [ ] Step 5: Typecheck and validate syntax
- [ ] Step 6: Use LSP to check for errors and warnings
- [ ] Step 7: Test the changes
```

### Step 1: Read source files

Read any relevant GDScript source files in the current project.

### Step 2: Look up relevant Godot documentation

Use the `godot:get_godot_class` tool to look up everything about a specific Godot class.
Use the `godot:search_godot_docs` tool to find a string in the Godot documentation.

### Step 3: Write or modify GDScript code

Adhere to the following rules while writing GDScript:
- Use the latest Godot 4.5 syntax and features, including typed arrays and dictionaries: `Array[int]`, `Dictionary[String, float]`, etc.
- Always use static typing
- Don't use `:=` type inference declarations for AI-generated code (prefer explicit annotations)
- Prefix private variables/methods with `_`
- Indent with tabs
- Use `@export` or dependency injection instead of hardcoded node paths
- Prefer methods with static typing over equivalent `StringName` variants

### Step 4: Import new files with Godot CLI

Run the Godot CLI with `--import` after adding new files, to make sure they get picked up by the editor:

```sh
godot --headless --import
```

This should be run in the project root directory (where `project.godot` is located). Remember that any folder containing `.gdignore` will be skipped during import.

### Step 5: Typecheck and validate syntax

Use the provided script to check the syntax of all GDScript files in the project:

```sh
scripts/check_syntax.sh
```

### Step 6: Use LSP to check for errors and warnings

Use the `ide:getDiagnostics` tool to check for any syntax or typechecking errors reported by the Godot LSP server. Note that this will only work correctly after `godot --import` (or else you may see spurious/out-of-date information), and only if the LSP server is running.

### Step 7: Test the changes

Use the testing workflow described in [testing.md](references/testing.md) to test your changes.

## Godot resource files (.tres, .tscn)

- NEVER manually assign or generate `uid://` fields—Godot fills these in automatically
