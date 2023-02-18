# Compile-time functions

V provides several compile-time functions.

## `$tmpl`

`$tmpl` is a compile-time function that allows you to embed a template into your code.

See [Templates](../templates/main.md) for more information.

## `$env`

V can bring in values at compile time from environment variables.

`$env('ENV_VAR')` can also be used in top-level `#flag` and `#include` statements:
`#flag linux -I $env('JAVA_HOME')/include`.

```v play
module main

fn main() {
	compile_time_env := $env('ENV_VAR')
	println(compile_time_env)
}
```

## `$compile_error` and `$compile_warn`

These two compile time functions are very useful for displaying custom errors/warnings during
compile time.

Both receive as their only argument a string literal that contains the message to display:

**example.v:**

```v play
$if linux {
	$compile_error('Linux is not supported')
}

fn main() {
}
```

Output:

```text
example.v:4:5: error: Linux is not supported
    2 |
    3 | $if linux {
    4 |     $compile_error('Linux is not supported')
      |     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    5 | }
    6 |
```
