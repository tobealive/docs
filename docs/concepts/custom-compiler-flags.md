# Custom Compiler Flags

V provides the ability to set custom compiler flags that can be used in program code.
With their help, you can, for example, execute code only if the flag was passed during compilation.
V will be able to optimize such code, and will not include it in the binary if the flag was not
passed.

To pass a custom flag, use the `-d` option followed by the flag name:

```v
v -d verbose_debug_output .
```

To pass multiple flags, use `-d` multiple times:

```v
v -d verbose_debug_output -d another_flag .
```

Now in code, we can use
[compile-time if](./compile-time/control-flow.md#if-expression)
to check if a flag was passed.

```v
fn busniness_logic() {
	$if verbose_debug_output ? {
		println('some verbose debug output')
	}

	// ...
}
```

> **Note**
> Notice the question mark after the flag name in the `$if` expression.

You can also use negation:

```v
fn busniness_logic() {
	$if !verbose_debug_output ? {
		println('verbose_debug_output flag was NOT passed')
	}

	// ...
}
```

Or `||` and `&&`:

```v
fn busniness_logic() {
	$if verbose_debug_output || another_flag ? {
		println('verbose_debug_output OR another_flag was passed')
	}

	// ...
}
```

You can add `$else $if` or `$else` which will work as normal conditions:

```v
fn busniness_logic() {
	$if verbose_debug_output ? {
		println('verbose_debug_output flag was passed')
	} $else $if another_flag ? {
		println('another_flag flag was passed')
	} $else {
		println('neither verbose_debug_output nor another_flag was passed')
	}

	// ...
}
```
