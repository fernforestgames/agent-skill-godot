---
name: godot
description: Develop games using the Godot engine. Use when the project directory contains a "project.godot" file. Requires Godot 4 and the `godot` MCP server (npm package `@fernforestgames/mcp-server-godot`) to be installed.
---

## GDScript workflow

When writing or modifying GDScript, copy this checklist and track your progress:

```
- [ ] Step 1: Read source files
- [ ] Step 2: Look up relevant Godot documentation
- [ ] Step 3: Write or modify GDScript code
- [ ] Step 4: Import new files with Godot CLI
- [ ] Step 5: Run syntax and typechecking with Godot CLI
- [ ] Step 6: Use LSP to check for errors and warnings
- [ ] Step 7: Launch the project to verify it runs correctly
```

**Step 1: Read source files**

Read any relevant GDScript source files in the current project.

**Step 2: Look up relevant Godot documentation**

Use the `godot:get_godot_class` tool
Use the `godot:search_godot_docs` tool 

**Step 3: Write or modify GDScript code**

Write or modify GDScript code as needed.

**Step 4: Import new files with Godot CLI**

Run the Godot CLI with `--import` after adding new files, to make sure they get picked up by the editor:

```sh
godot --headless --import
```

This should be run in the project root directory (where `project.godot` is located).

**Step 5: Run syntax and typechecking with Godot CLI**

Pass an individual script file to the Godot CLI to check for syntax and typechecking errors:

```sh
godot --headless --script SCRIPT_FILE.gd --check-only
```

This should be run in the project root directory (where `project.godot` is located).

**Step 6: Use LSP to check for errors and warnings**

Use the `ide:getDiagnostics` tool to check for any syntax or typechecking errors reported by the Godot LSP server. Note that this will only work correctly after `godot --import` (or else you may see spurious/out-of-date information), and only if the LSP server is running.

**Step 7: Launch the project to verify it runs correctly**

Run the project using the Godot CLI to make sure it launches successfully (you can also pass a `.tscn` filepath to launch a specific scene).

Make sure you have an automatic exit in there, or a way to time out the process, because it will run forever by default! 
