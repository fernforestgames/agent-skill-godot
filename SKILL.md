---
name: godot
description: "MANDATORY for ALL GDScript/.gd files and Godot resources (.tscn, .tres). Invoke this skill FIRST before writing ANY Godot code—never write GDScript directly without this skill. Provides documentation lookup, syntax checking, and testing instructions."
---

# Godot development

Requires Godot 4 and the `godot-docs` MCP server (npm package `@fernforestgames/mcp-server-godot-docs`) to be installed.

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

Use the `godot-docs:get_godot_class` tool to look up everything about a specific Godot class.
Use the `godot-docs:search_godot_docs` tool to find a string in the Godot documentation.

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

Use the testing workflow described below to test your changes.

## Testing workflow

### Manual testing

Run the project using the Godot CLI to make sure it launches successfully:

```sh
godot
```

This should be run in the project root directory (where `project.godot` is located). Background the task, because it will run forever by default!

You can also pass a `.tscn` filepath to run a specific scene:

```sh
godot scene.tscn
```

### Automated tests

Unit tests can be written with the GUT (Godot Unit Test) framework:
https://github.com/bitwes/Gut
https://gut.readthedocs.io

If not already present in the current project in the `addons/` directory, do NOT attempt to install it. Ask the user to install it from the Godot Asset Library instead.

#### Writing tests

Test cases should be scripts that extend `GutTest`:

```gdscript
extends GutTest

# GUT assertions are untyped, so disable this warning
@warning_ignore_start("unsafe_call_argument")

func before_all():
	pass

func before_each():
	pass

func test_passes():
	assert_eq(1, 1)

func test_fails():
	assert_eq("hello", "goodbye")

func after_each():
	pass

func after_all():
	pass
```

Run the Godot CLI with `--import` after adding new files, to make sure they get picked up by the editor:

```sh
godot --headless --import
```

This should be run in the project root directory (where `project.godot` is located).

**Assertions**

```gdscript
assert_true(got)
assert_false(got)
assert_null(got)
assert_not_null(got)

assert_eq(got, expected)
assert_eq_deep(got, expected)  # Like assert_eq but more detailed failure messages for nested collections
assert_almost_eq(got, expected, error_interval)
assert_ne(got, not_expected)
assert_ne_deep(got, not_expected)
assert_almost_ne(got, not_expected, error_interval)
assert_gt(got, expected)
assert_gte(got, expected)
assert_lt(got, expected)
assert_lte(got, expected)

assert_same(got, expected)  # Checks that reference types (Object, Dictionary, Array) are exactly the same reference
assert_not_same(got, expected)

assert_has(obj, element)
assert_does_not_have(obj, element)

assert_is(obj, class_or_script_obj)
assert_typeof(obj, type_constant)  # TYPE_INT, TYPE_STRING, etc.
assert_not_typeof(obj, type_constant)

assert_engine_error(matching_text)
assert_engine_error_count(count)
assert_push_error(matching_text)
assert_push_error_count(count)
assert_push_warning(matching_text)
assert_push_warning_count(count)

assert_freed(obj)
assert_not_freed(obj)
```

**Helpers**

```gdscript
await wait_seconds(10)
await wait_idle_frames(5)  # 5 _process frames
await wait_physics_frames(2)
await wait_for_signal(scene_tree.node_removed, 3)  # time out after 3 seconds
await wait_until(callable, 3)  # time out after 3 seconds
```

#### Running tests

Once tests have been written and imported, run them using the GUT command line script:

```sh
godot --headless --script addons/gut/gut_cmdln.gd

# Run a specific test file
godot --headless --script addons/gut/gut_cmdln.gd -gtest=res://tests/sample_tests.gd
```

GUT is configured with an optional `res://.gutconfig.json` file. A sample can be generated with:

```sh
godot --headless --script addons/gut/gut_cmdln.gd -gprint_gutconfig_sample
```

#### Visual testing with screenshots

To verify rendering, write GUT tests that capture screenshots via `get_viewport().get_texture().get_image()` and save them to `tests/screenshots/`. After running (without `--headless`), use the `Read` tool to view the saved PNGs and verify visuals.

The screenshot directory should be in `.gitignore` and contain a `.gdignore` file to prevent Godot from importing the images.

## Godot resource files (.tres, .tscn)

- NEVER manually assign or generate `uid://` fields—Godot fills these in automatically

### Connecting @exports in scene files

When a script uses `@export var some_node: SomeNodeType`, you can assign it via a `.tscn` file:
```
[node name="MyNode" type="Node3D" parent="." node_paths=PackedStringArray("player", "camera")]
script = ExtResource("1_abc123")
player = NodePath("../Player")
camera = NodePath("CameraPivot/Camera3D")
```
