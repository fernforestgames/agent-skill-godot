# Testing Godot projects

## Manual testing

Run the project using the Godot CLI to make sure it launches successfully:

```sh
godot
```

This should be run in the project root directory (where `project.godot` is located).

You can also pass a `.tscn` filepath to run a specific scene:

```sh
godot scene.tscn
```

Make sure you have an automatic exit in there, or a way to time out the process, because it will run forever by default! 

## Automated tests

Unit tests can be written with the GUT (Godot Unit Test) framework:
https://github.com/bitwes/Gut
https://gut.readthedocs.io

If not already present in the current project in the `addons/` directory, do NOT attempt to install it. Ask the user to install it from the Godot Asset Library instead.

### Writing tests

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

#### Assertions

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

#### Helpers

```gdscript
await wait_seconds(10)
await wait_idle_frames(5)  # 5 _process frames
await wait_physics_frames(2)
await wait_for_signal(scene_tree.node_removed, 3)  # time out after 3 seconds
await wait_until(callable, 3)  # time out after 3 seconds
```

### Running tests

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
