# Custom Compiler Options

V provides the ability to set custom compiler options that can be used in program code.
With their help, you can, for example, execute code only if the option was
passed during compilation.
V will be able to optimize such code, and will not include it in the binary if the option was not
passed.

To pass a custom option, use the `-d` flag followed by the option name:

```bash
v -d verbose_debug_output .
```

To pass multiple options, use `-d` multiple times:

```bash
v -d verbose_debug_output -d another_flag .
```

Now in code, we can use
[compile-time if](./compile-time/control-flow.md#if-expression)
to check if a option was passed.

```v ignore
fn busniness_logic() {
	$if verbose_debug_output ? {
		println('some verbose debug output')
	}

	// ...
}
```

> **Note**
> Notice the question mark after the option name in the `$if` expression.

You can also use negation:

```v ignore
fn busniness_logic() {
	$if !verbose_debug_output ? {
		println('verbose_debug_output option was NOT passed')
	}

	// ...
}
```

Or `||` and `&&`:

```v ignore
fn busniness_logic() {
	$if verbose_debug_output || another_option ? {
		println('verbose_debug_output OR another_option was passed')
	}

	// ...
}
```

You can add `$else $if` or `$else` which will work as normal conditions:

```v ignore
fn busniness_logic() {
	$if verbose_debug_output ? {
		println('verbose_debug_output option was passed')
	} $else $if another_flag ? {
		println('another_option option was passed')
	} $else {
		println('neither verbose_debug_output nor another_option was passed')
	}

	// ...
}
```
